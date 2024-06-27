import 'package:beyond_seoul/network/network_manager.dart';
import 'package:beyond_seoul/view/screens/leader_code_screen.dart';
import 'package:beyond_seoul/view/widgets/button_icon.dart';
import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:beyond_seoul/view/widgets/user_container.dart';
import 'package:beyond_seoul/view_model/onboarding_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../network/api_response.dart';
import '../../../network/api_url.dart';
import '../../../routes/routes_name.dart';
import '../../../statics/colors.dart';
import '../../../statics/images.dart';
import '../../../statics/strings.dart';
import '../../../view_model/login_view_model.dart';
import '../../widgets/back_app_bar.dart';
import '../../widgets/image_button.dart';
import '../../widgets/schedule_widget.dart';
import '../error_screen.dart';
import '../mate_code_screen.dart';
import 'onboarding_button.dart';

enum Page {
  ageBirthPage,
  withTravelPage,
  rolePage,
  travelDatePage,
  themaPage,
  destionPage
}

Map<int, String> ageMap = {0: "남", 1: "여"};

Map<int, String> withTravelMap = {0: "혼자", 1: "여행 메이트와 함께"};

Map<int, String> roleMap = {0: "리더에요!", 1: "메이트에요!"};

Map<int, String> themeMap = {
  0: "음식",
  1: "산림",
  2: "역사/문화",
  3: "바다",
  4: "레저",
  5: "쇼핑"
};

class OnboardingScreen extends StatefulWidget {
  final bool isFirst;

  const OnboardingScreen({super.key, required this.isFirst});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  LoginViewModel _loginViewModel = LoginViewModel();
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = -1;
  String _age = "";
  String _birthday = "";
  String _withTravel = "";
  String _travelStartDate = "";
  String _travelEndDate = "";
  String _role = "";
  int _themeId = 0;
  String _destination = "";
  late OnboardingViewModel _onboardingViewModel;
  VoidCallback? _retryCallback;
  DateTime _birthdayDate = DateTime.now();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _onboardingViewModel = OnboardingViewModel();
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    _onboardingViewModel.fetchThemaListApi();
  }

  String dateToStringFormat(DateTime time) {
    DateFormat format = DateFormat('yyyy-MM-dd');
    return format.format(time);
  }

  void _setTravelStartDate(DateTime time) {
    _travelStartDate = dateToStringFormat(time);
    setState(() {});
  }

  void _setTravelEndDate(DateTime time) {
    _travelEndDate = dateToStringFormat(time);
    setState(() {});
  }

  void _clearStartDate() {
    setState(() {
      _travelStartDate = "";
    });
  }

  void _clearEndDate() {
    setState(() {
      _travelEndDate = "";
    });
  }

  void _setThemeId(int index) {
    _themeId = index;
  }

  String _formatDateInput(String text) {
    text = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.length > 4 && text.length <= 6) {
      text = text.substring(0, 4) + '-' + text.substring(4);
    } else if (text.length > 6) {
      text = text.substring(0, 4) +
          '-' +
          text.substring(4, 6) +
          '-' +
          text.substring(6);
    }
    return text;
  }

  Widget buildOnboardingButton(int index, String text, double height) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: OnboardingButton(
        width: ScreenUtil().setWidth(160),
        height: ScreenUtil().setHeight(height),
        text: text,
        enable: _selectedIndex == index,
      ),
    );
  }

  Widget buildImageButton(int index, double width, double height,
      String enabledImage, String disabledImage) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: ImageButton(
        enabledImage: enabledImage,
        disabledImage: disabledImage,
        width: width,
        height: height,
        enable: _selectedIndex == index,
      ),
    );
  }

  List<Widget> _buildThemeImageRows() {
    List<Widget> rows = [];
    List<String> imageUrls = _onboardingViewModel.themaData.data?.data.themes
            .map((theme) => theme.image)
            .toList() ??
        [];
    List<String> themeNames = _onboardingViewModel.themaData.data?.data.themes
            .map((theme) => theme.themeName)
            .toList() ??
        [];

    for (var i = 0; i < imageUrls.length; i += 2) {
      var rowWidgets = <Widget>[];
      for (var j = i; j < i + 2 && j < imageUrls.length; j++) {
        rowWidgets.add(_networkImageButton(imageUrls[j], themeNames[j], j));
        if (j < i + 1) {
          rowWidgets.add(const Spacer());
        }
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: rowWidgets,
      ));

      if (i + 2 < imageUrls.length) {
        rows.add(SizedBox(height: ScreenUtil().setHeight(4)));
      }
    }

    return rows;
  }

  List<Widget> _buildDestinationImageColumns() {
    List<Widget> columns = [];
    List<String> imageUrls = _onboardingViewModel
            .destinationData.data?.data.destinations
            .map((destination) => destination.image)
            .toList() ??
        [];
    List<String> themeNames = _onboardingViewModel
            .destinationData.data?.data.destinations
            .map((destination) => destination.destination)
            .toList() ??
        [];

    for (var i = 0; i < imageUrls.length; i++) {
      columns.add(_destinationButton(imageUrls[i], themeNames[i], i));

      if (i < imageUrls.length - 1) {
        columns.add(SizedBox(height: ScreenUtil().setHeight(4)));
      }
    }

    return columns;
  }

  Widget _networkImageButton(String imageUrl, String themeName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Stack(
        children: [
          Opacity(
            opacity: _selectedIndex == index ? 1.0 : 0.5,
            child: Image.network(
              imageUrl,
              width: ScreenUtil().setWidth(168),
              height: ScreenUtil().setHeight(160),
            ),
          ),
          Positioned(
            right: ScreenUtil().setWidth(15.0),
            bottom: ScreenUtil().setHeight(15.0),
            child: Text(
              themeName,
              style: const TextStyle(
                fontFamily: "Pretendard",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _destinationButton(String imageUrl, String themeName, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        height: ScreenUtil().setHeight(157.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8.0)),
          border: Border.all(
            color: (_selectedIndex == index)
                ? const Color(0xFF2E3192)
                : const Color(0xFFD2D2D2),
            width: ScreenUtil().setWidth(2.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: ScreenUtil().setWidth(5.0)),
            Image.network(
              imageUrl,
              width: ScreenUtil().setWidth(143),
              height: ScreenUtil().setHeight(143),
            ),
            SizedBox(width: ScreenUtil().setWidth(12.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setHeight(7.0)),
                  Text(
                    _onboardingViewModel.destinationData.data?.data
                            .destinations[index].destination ??
                        '',
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(11.0)),
                  Text(
                    _onboardingViewModel.destinationData.data?.data
                            .destinations[index].detail ??
                        '',
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7E7E7E),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(10.0)),
          ],
        ),
      ),
    );
  }

  void _writeStorage(String key, String result) async {
    await _storage.write(
      key: key,
      value: result,
    );
  }

  Future<void> _sendOnboardingComplete() async {
    _onboardingViewModel.setApiResponse(ApiResponse.loading());

    Map<String, dynamic> data = {
      "age": _age,
      "birth": _birthday,
      "destination": _destination,
      "lang": "한국어",
      "role": _role,
      "themaId": _themeId,
      "travelEndDate": _travelEndDate,
      "travelStartDate": _travelStartDate,
      "travelWith": _withTravel,
      "uid": _loginViewModel.getUid,
    };

    return NetworkManager.instance
        .post(ApiUrl.onboardingComplete, data)
        .then((response) {
      if (response.statusCode == 200) {
        _retryCallback = null;

        _writeStorage(Strings.loginKey, "true");
        Navigator.of(context).pushReplacementNamed(RoutesName.app);
      } else {
        _retryCallback = () => _sendOnboardingComplete();
        _onboardingViewModel.setApiResponse(ApiResponse.error());
      }
    }).catchError((error) {
      _retryCallback = () => _sendOnboardingComplete();
      _onboardingViewModel.setApiResponse(ApiResponse.error());
    });
  }

  void _nextClickEvent(Page page) async {
    FocusManager.instance.primaryFocus?.unfocus();

    switch (page) {
      case Page.ageBirthPage:
        _age = ageMap[_selectedIndex] ?? "";
        _pageController.jumpToPage(Page.withTravelPage.index);
        break;
      case Page.withTravelPage:
        _withTravel = withTravelMap[_selectedIndex] ?? "";

        if (_selectedIndex == 0) {
          _pageController.jumpToPage(Page.travelDatePage.index);
        } else {
          _pageController.jumpToPage(Page.rolePage.index);
        }
        break;
      case Page.rolePage:
        _role = roleMap[_selectedIndex] ?? "";

        if (_selectedIndex == 0) {
          _pageController.jumpToPage(Page.travelDatePage.index);
        } else {
          // _sendOnboardingComplete();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MateReCodeScreen()),
          );
        }
        break;
      case Page.travelDatePage:
        _pageController.jumpToPage(Page.themaPage.index);
        break;
      case Page.themaPage:
        _themeId = _selectedIndex + 1;
        _selectedIndex += 1;
        Map<String, String> queryParams = {"themeId": _themeId.toString()};

        _setThemeId(_selectedIndex);
        _onboardingViewModel.fetchDestinationListApi(queryParams).then((_) {
          _pageController.jumpToPage(Page.destionPage.index);
        }).catchError((error) {});

        break;
      case Page.destionPage:
        _destination = _onboardingViewModel.destinationData.data?.data
                .destinations[_selectedIndex].destination ??
            "";
        _onboardingViewModel.setApiResponse(ApiResponse.loading());
        _sendOnboardingComplete();

        break;
    }

    setState(() {
      _selectedIndex = -1;
    });
  }

  void _backKeyHandler() {
    if (_pageController.page == 0) {
      Navigator.pop(context);
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: ScreenUtil().setHeight(250.0),
          child: CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                dateTimePickerTextStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(18.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Pretendard",
                ),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(200.0),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        _birthdayDate = newDateTime;
                        _birthday = dateToStringFormat(_birthdayDate);
                      });
                    },
                    dateOrder: DatePickerDateOrder.ymd,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOnboardingPage({
    required String progressImage,
    required String title,
    required List<Widget> children,
    required VoidCallback onNext,
    required bool nextEnabled,
  }) {
    return Scaffold(
      appBar: BackAppBar(
        title: '',
        callBack: _backKeyHandler,
      ),
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(progressImage),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(65)),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    ...children,
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40)),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
              child: GestureDetector(
                onTap: onNext,
                child: InfinityButton(
                  height: 40,
                  radius: 4,
                  backgroundColor: nextEnabled
                      ? const Color(UserColors.enable)
                      : const Color(UserColors.disable),
                  text: Strings.next,
                  textColor: Colors.white,
                  textSize: 16,
                  textWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OnboardingViewModel>(
      create: (BuildContext context) => _onboardingViewModel,
      child: Consumer<OnboardingViewModel>(
        builder: (context, value, _) {
          switch (value.apiResponse.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.complete:
              return PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (widget.isFirst)
                    _buildOnboardingPage(
                      progressImage: Images.onboardingProgress1,
                      title: Strings.pleaseGender,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildOnboardingButton(
                                    0, Strings.man, ScreenUtil().setHeight(78)),
                                buildOnboardingButton(
                                    1, Strings.girl, ScreenUtil().setHeight(78)),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(131.0)),
                            Text(
                              Strings.pleaseBirthday,
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: ScreenUtil().setSp(16.0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(32.0)),
                            UserContainer(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(78),
                                backgroundColor: Colors.white,
                                borderRadius: ScreenUtil().radius(4.0),
                                callback: () =>
                                    _showDatePickerBottomSheet(context),
                                child: Center(
                                  child: Text(
                                    _birthday,
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontSize: ScreenUtil().setSp(16.0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                      onNext: () {
                        if (_selectedIndex != -1) {
                          _nextClickEvent(Page.ageBirthPage);
                        }
                      },
                      nextEnabled: _selectedIndex != -1 && _birthday.isNotEmpty,
                    ),
                  _buildOnboardingPage(
                    progressImage: Images.onboardingProgress3,
                    title: Strings.howManyMate,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(198)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOnboardingButton(
                              0, Strings.alone, ScreenUtil().setHeight(78)),
                          buildOnboardingButton(1, Strings.withTravelMate,
                              ScreenUtil().setHeight(78)),
                        ],
                      ),
                    ],
                    onNext: () {
                      if (_selectedIndex != -1) {
                        _nextClickEvent(Page.withTravelPage);
                      }
                    },
                    nextEnabled: _selectedIndex != -1,
                  ),
                  _buildOnboardingPage(
                    progressImage: Images.onboardingProgress4,
                    title: Strings.whatRole,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(154)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildOnboardingButton(
                              0, Strings.isReader, ScreenUtil().setHeight(78)),
                          buildOnboardingButton(1, Strings.togetherMage,
                              ScreenUtil().setHeight(78)),
                        ],
                      ),
                    ],
                    onNext: () {
                      if (_selectedIndex != -1) {
                        _nextClickEvent(Page.rolePage);
                      }
                    },
                    nextEnabled: _selectedIndex != -1,
                  ),
                  _buildOnboardingPage(
                    progressImage: Images.onboardingProgress5,
                    title: Strings.pleaseSchedule,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(75)),
                      const Text(
                        Strings.koreanArrivalDate,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      GestureDetector(
                        onTap: () {
                          showScheduleBottomSheet(
                            context,
                            _setTravelStartDate,
                            endDateDisable: DateTime.tryParse(_travelEndDate),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: ScreenUtil().setHeight(58),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(29)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _travelStartDate.isNotEmpty
                                          ? _travelStartDate
                                          : Strings.travelStartGuide,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Pretendard",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ButtonIcon(
                                      icon: Icons.close,
                                      iconColor: Colors.black,
                                      callback: () => _clearStartDate()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(75)),
                      const Text(
                        Strings.returnHomewtownDate,
                        style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(12)),
                      GestureDetector(
                        onTap: () {
                          showScheduleBottomSheet(
                            context,
                            _setTravelEndDate,
                            startDate: DateTime.tryParse(_travelStartDate),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: ScreenUtil().setHeight(58),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(29)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _travelEndDate.isNotEmpty
                                          ? _travelEndDate
                                          : Strings.travelEndGuide,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Pretendard",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ButtonIcon(
                                      icon: Icons.close,
                                      iconColor: Colors.black,
                                      callback: () => _clearEndDate()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onNext: () {
                      if (_travelStartDate.isNotEmpty &&
                          _travelEndDate.isNotEmpty) {
                        _nextClickEvent(Page.travelDatePage);
                      }
                    },
                    nextEnabled: _travelStartDate.isNotEmpty &&
                        _travelEndDate.isNotEmpty,
                  ),
                  _buildOnboardingPage(
                    progressImage: Images.onboardingProgress7,
                    title: Strings.pleaseTravelThema,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      ..._buildThemeImageRows(),
                    ],
                    onNext: () {
                      if (_selectedIndex != -1) {
                        _nextClickEvent(Page.themaPage);
                      }
                    },
                    nextEnabled: _selectedIndex != -1,
                  ),
                  _buildOnboardingPage(
                    progressImage: Images.onboardingProgress8,
                    title: Strings.pleaseDestination,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      ..._buildDestinationImageColumns(),
                    ],
                    onNext: () {
                      if (_selectedIndex != -1) {
                        _nextClickEvent(Page.destionPage);
                      }
                    },
                    nextEnabled: _selectedIndex != -1,
                  ),
                ],
              );
            case Status.error:
            default:
              return ErrorScreen(onRetry: _retryCallback);
          }
        },
      ),
    );
  }
}
