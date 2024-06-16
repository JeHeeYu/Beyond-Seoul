import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:beyond_seoul/network/api_url.dart';
import 'package:beyond_seoul/network/network_manager.dart';
import 'package:beyond_seoul/statics/colors.dart';
import 'package:beyond_seoul/view/screens/error_screen.dart';
import 'package:beyond_seoul/view/widgets/complete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../services/naver_map_service.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/login_view_model.dart';
import '../../view_model/record_view_model.dart';
import '../widgets/button_icon.dart';
import '../widgets/flexible_text.dart';
import '../widgets/infinity_button.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import 'home_screen.dart';

class MissionDetailScreen extends StatefulWidget {
  MissionDetailScreen({
    Key? key,
    required this.title,
    required this.missionType,
    required this.missionId,
    required this.travelId,
    required this.missionValue,
  }) : super(key: key);

  String title;
  final String missionType;
  int missionId;
  final String travelId;
  final MissionType missionValue;

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  LoginViewModel _loginViewModel = LoginViewModel();
  RecordViewModel _recordViewModel = RecordViewModel();
  final _commentController = TextEditingController();
  XFile? uploadImage;
  final ImagePicker picker = ImagePicker();
  dynamic sendData;
  VoidCallback? _retryCallback;
  String _address = "";
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();

    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMissionDetail();
    });
  }

  void _fetchMissionDetail() {
    Map<String, int> missionId = {"missionId": widget.missionId};

    try {
      _recordViewModel.fetchMissionDetail(missionId).then((_) {
        _retryCallback = null;
      }).catchError((error) {
        _retryCallback = () => _fetchMissionDetail();
        _recordViewModel.setApiResponse(ApiResponse.error());
      });
    } catch (error) {
      _retryCallback = () => _fetchMissionDetail();
      _recordViewModel.setApiResponse(ApiResponse.error());
    }
  }

  void _missionRefresh() async {
    Map<String, String> data = {
      "missionId": widget.missionId.toString(),
    };

    NetworkManager.instance
        .postQuery(ApiUrl.missionRefresh, data)
        .then((response) {
      print("POST 성공 145623: ${response}");
      Map<String, String> queryParams = {"uid": _loginViewModel.getUid};
      _homeViewModel.fetchTravelListApi(queryParams);
      _updateMissionData();
    }).catchError((error) {
      print("에러 발생 123123: $error");
    });
  }

  void _updateMissionData() {
    if (widget.missionValue == MissionType.food) {
      widget.title =
          _homeViewModel.homeData.data?.data.ongoingMission.foodMission ?? '';
      widget.missionId =
          _homeViewModel.homeData.data?.data.ongoingMission.foodMissionId ?? 0;
    } else if (widget.missionValue == MissionType.tour) {
      widget.title =
          _homeViewModel.homeData.data?.data.ongoingMission.tourMission ?? '';
      widget.missionId =
          _homeViewModel.homeData.data?.data.ongoingMission.tourMissionId ?? 0;
    } else if (widget.missionValue == MissionType.soso) {
      widget.title =
          _homeViewModel.homeData.data?.data.ongoingMission.sosoMission ?? '';
      widget.missionId =
          _homeViewModel.homeData.data?.data.ongoingMission.sosoMissionId ?? 0;
    }

    setState(() {});
  }

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 30);

    if (pickedFile != null) {
      setState(() {
        uploadImage = XFile(pickedFile.path);
        sendData = pickedFile.path;
      });
    }
  }

  Widget _buildPhotoArea() {
    return uploadImage != null
        ? SizedBox(
            width: 360,
            height: 360,
            child: Image.file(File(uploadImage!.path)),
          )
        : Image.asset(Images.photoUpload);
  }

  void _sendRecordCreate() async {
    String imagePath = uploadImage?.path ?? "";
    Uint8List? imageBytes;
    if (uploadImage != null) {
      imageBytes = await File(imagePath).readAsBytes();
    }

    Map<String, dynamic> data = {
      "missionType": widget.missionType,
      "missionId": widget.missionId,
      "recordComment": _commentController.text,
      "uid": _loginViewModel.getUid,
      "travelId": widget.travelId
    };

    try {
      await _recordViewModel.createRecord(data, imageBytes).then((_) {
        _retryCallback = null;

        if (mounted) {
          Navigator.pop(context);
        }
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                const CompleteDialog(title: Strings.recordComplete),
          ).then((_) {});
        }
      }).catchError((error) {
        _retryCallback = () => _sendRecordCreate();
        _recordViewModel.setApiResponse(ApiResponse.error());
      });
    } catch (error) {
      _retryCallback = () => _sendRecordCreate();
      _recordViewModel.setApiResponse(ApiResponse.error());
    }
  }

  void _refresh() {
    setState(() {
      uploadImage = null;
      _missionRefresh();
      _commentController.clear();
    });
  }

  Future<Uint8List?> getStaticMap() async {
    double lat = _recordViewModel.missionDetail.data?.data.lat ?? 0.0;
    double lon = _recordViewModel.missionDetail.data?.data.lon ?? 0.0;
    if (lat == 0.0 || lon == 0.0) {
      return null;
    }
    Uint8List? staticMapBytes =
        await NaverMapService.getStaticMapImage(lat, lon);
    return staticMapBytes;
  }

  void _locationCopy(String location) {
    Clipboard.setData(ClipboardData(text: location));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('복사 되었습니다!')),
    );
  }

  Widget _buildAppBarWidget() {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(92),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(UserColors.disable), width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonIcon(
            icon: Icons.arrow_back_ios,
            iconColor: Colors.black,
            callback: () {
              Navigator.pop(context);
            },
          ),
          FlexibleText(
            text: widget.title,
            textSize: 18,
            textWeight: FontWeight.w700,
          ),
          ButtonIcon(
            icon: Icons.refresh,
            iconColor: Colors.black,
            callback: () {
              _refresh();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTravelDetail() {
    return Text(
      _recordViewModel.missionDetail.data?.data.detail ?? '',
      style: TextStyle(
        color: const Color(UserColors.guideText),
        fontFamily: "Pretendard",
        fontSize: ScreenUtil().setSp(14.0),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationWidget() {
    return FutureBuilder<Uint8List?>(
      future: getStaticMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container();
        } else {
          Uint8List? staticMapBytes = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strings.location,
                style: TextStyle(
                  color: const Color(UserColors.guideText),
                  fontFamily: "Pretendard",
                  fontSize: ScreenUtil().setSp(14.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(4.0)),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: ScreenUtil().setWidth(14.0),
                  ),
                  Text(
                    _address,
                    style: TextStyle(
                      color: const Color(UserColors.guideText),
                      fontFamily: "Pretendard",
                      fontSize: ScreenUtil().setSp(12.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ButtonIcon(
                      icon: Icons.copy,
                      callback: () => _locationCopy("location"),
                      iconColor: Colors.grey,
                      iconSize: ScreenUtil().setWidth(14.0)),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(9.0)),
              if (staticMapBytes != null) Image.memory(staticMapBytes),
            ],
          );
        }
      },
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(22)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTravelDetail(),
              SizedBox(height: ScreenUtil().setHeight(29)),
              _buildLocationWidget(),
              GestureDetector(
                onTap: () async {
                  getImage(ImageSource.gallery);
                },
                child: _buildPhotoArea(),
              ),
              SizedBox(height: ScreenUtil().setHeight(19)),
              const Divider(thickness: 1),
              SizedBox(height: ScreenUtil().setHeight(19)),
              Container(
                height: ScreenUtil().setHeight(150),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFDEDEDE),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _commentController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(UserColors.mainBackGround),
                    hintText: Strings.photoUploadHint,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompleteWidget(RecordViewModel value) {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22)),
        child: Column(
          children: [
            SizedBox(
                height:
                    ScreenUtil().statusBarHeight + ScreenUtil().setHeight(20)),
            _buildAppBarWidget(),
            _buildMainContent(),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(63)),
              child: GestureDetector(
                onTap: () {
                  _sendRecordCreate();
                },
                child: InfinityButton(
                  height: 40,
                  radius: 4,
                  backgroundColor: (uploadImage == null)
                      ? const Color(UserColors.disable)
                      : const Color(UserColors.enable),
                  text: Strings.missionComplete,
                  textSize: 16,
                  textWeight: FontWeight.w700,
                  textColor: Colors.white,
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
    return ChangeNotifierProvider<RecordViewModel>(
      create: (BuildContext context) => _recordViewModel,
      child: Consumer<RecordViewModel>(
        builder: (context, value, _) {
          switch (value.apiResponse.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.complete:
              return _buildCompleteWidget(value);
            case Status.error:
            default:
              return ErrorScreen(onRetry: _retryCallback);
          }
        },
      ),
    );
  }
}
