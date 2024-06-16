import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'record_feed_screen.dart';
import 'error_screen.dart';
import '../../models/record/record_read_model.dart';
import '../../network/api_response.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/login_view_model.dart';
import '../../view_model/record_view_model.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();

  void fetchRecords(BuildContext context) {
    final _recordViewModel = Provider.of<RecordViewModel>(context, listen: false);
    final _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    Map<String, String> data = {
      "cursorId": "0",
      "size": "0",
      "uid": _loginViewModel.getUid,
      "travelId": "0"
    };

    _recordViewModel.fetchRecordView(data).then((_) {
      _RecordScreenState().updateDateList(context);
    });
  }
}

class _RecordScreenState extends State<RecordScreen> {
  late RecordViewModel _recordViewModel;
  late HomeViewModel _homeViewModel;
  late LoginViewModel _loginViewModel;
  List<String> _dates = [];
  String? _selectDate;
  int _selectTravelsIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _recordViewModel = Provider.of<RecordViewModel>(context, listen: false);
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    fetchRecords();
  }

  void fetchRecords() {
    Map<String, String> data = {
      "cursorId": "0",
      "size": "0",
      "uid": _loginViewModel.getUid,
      "travelId": "0"
    };

    _recordViewModel.fetchRecordView(data).then((_) {
      updateDateList(context);
    });
  }

  void updateDateList(BuildContext context) {
    if (_recordViewModel.recordData.status == Status.complete) {
      List<DateTime> uniqueDates = [];
      for (var content in _recordViewModel.recordData.data?.data.content ?? []) {
        DateTime uploadDate = DateTime.parse(content.uploadAt);
        String formattedDate = DateFormat('yyyy년 MM월').format(uploadDate);
        DateTime formattedDateTime = DateFormat('yyyy년 MM월').parse(formattedDate);
        if (!uniqueDates.contains(formattedDateTime)) {
          uniqueDates.add(formattedDateTime);
        }
      }

      uniqueDates.sort((a, b) => b.compareTo(a));
      List<String> formattedDates = uniqueDates
          .map((date) => DateFormat('yyyy년 MM월').format(date))
          .toList();
      formattedDates.insert(0, Strings.allViewRecord);

      setState(() {
        _dates = formattedDates;
        _selectDate = _dates.isNotEmpty ? _dates.first : null;
      });
    }
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
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              Strings.record,
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
      child: Image.asset(Images.emptyRecord),
    );
  }

  Widget _buildCompleteWidget(RecordViewModel value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayWidget(),
          value.recordData.data?.data.content.isEmpty == true
              ? _buildEmptyWidget()
              : _buildImageWidget(value),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Consumer<RecordViewModel>(
      builder: (context, value, _) {
        switch (value.recordData.status) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());
          case Status.complete:
            return _buildCompleteWidget(value);
          case Status.error:
          default:
            return const ErrorScreen();
        }
      },
    );
  }

  Widget _buildDayWidget() {
    return DropdownButton(
      value: _selectDate,
      items: _dates
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          _selectTravelsIndex = _dates.indexOf(value);
          setState(() {
            _selectDate = value;
          });
        }
      },
    );
  }

  Widget _buildImageWidget(RecordViewModel value) {
    List<RecordContent> filteredContent;

    if (_selectDate == Strings.allViewRecord) {
      filteredContent = value.recordData.data?.data.content ?? [];
    } else {
      filteredContent = value.recordData.data?.data.content.where((item) {
        return DateFormat('yyyy년 MM월')
                .format(DateTime.parse(item.uploadAt)) ==
            _selectDate;
      }).toList() ??
          [];
    }

    if (filteredContent.isEmpty) {
      return _buildEmptyWidget();
    }

    return Expanded(
      child: GridView.builder(
        itemCount: filteredContent.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordFeedScreen(
                    date: _selectDate!,
                    pageIndex: index,
                    selectTravelsIndex: _selectTravelsIndex,
                  ),
                ),
              );
            },
            child: Image.network(
              filteredContent[index].image,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecordViewModel>.value(
      value: _recordViewModel,
      child: Scaffold(
        backgroundColor: const Color(UserColors.mainBackGround),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22)),
          child: Column(
            children: [
              SizedBox(
                  height: ScreenUtil().statusBarHeight +
                      ScreenUtil().setHeight(20)),
              _buildAppBarWidget(),
              SizedBox(height: ScreenUtil().setHeight(16)),
              _buildMainContent(),
              SizedBox(height: ScreenUtil().setHeight(32)),
            ],
          ),
        ),
      ),
    );
  }
}