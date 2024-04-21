import 'package:beyond_seoul/view/screens/record_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../statics/colors.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../../view_model/record_view_model.dart';
import 'error_screen.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  RecordViewModel _recordViewModel = RecordViewModel();
  List<String> _dates = [];
  String? _selectDate;
  int _selectTravelsIndex = 0;

  @override
  void initState() {
    super.initState();

    _recordViewModel = Provider.of<RecordViewModel>(context, listen: false);
    _recordViewModel.fetchRecordImageApi().then((_) {
      if (_recordViewModel.recordData.status == Status.complete) {
        print("Jehee test");
        _dates = List<String>.from(_recordViewModel
            .recordData.data!.data.travels
            .map((travel) => travel.title));
        _selectDate = _dates[0];
        setState(() {});
      }
      else {
                print("Jehee test");
      }
    });
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
        child: Image.asset(Images.emptyRecord));
  }

  Widget _buildCompleteWidget(RecordViewModel value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayWidget(),
          value.recordData.data?.data.travels[_selectTravelsIndex].records
                      .isEmpty ??
                  false
              ? _buildEmptyWidget()
              : _buildImageWidget(value),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider<RecordViewModel>(
      create: (BuildContext context) => _recordViewModel,
      child: Consumer<RecordViewModel>(
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
      ),
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
    return Expanded(
      child: GridView.builder(
        itemCount: value
            .recordData.data?.data.travels[_selectTravelsIndex].records.length,
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
                          date: _dates[_selectTravelsIndex],
                          pageIndex: index,
                          selectTravelsIndex: _selectTravelsIndex,
                        )),
              );
            },
            child: Image.network(
              value.recordData.data?.data.travels[_selectTravelsIndex]
                      .records[index].image ??
                  "",
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: ScreenUtil().setHeight(16)),
            _buildMainContent(),
            SizedBox(height: ScreenUtil().setHeight(32)),
          ],
        ),
      ),
    );
  }
}
