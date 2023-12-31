import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../statics/colors.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/record_view_model.dart';

class RecordFeedScreen extends StatefulWidget {
  final String date;
  final int pageIndex;
  final int selectTravelsIndex;

  const RecordFeedScreen(
      {Key? key, required this.date, required this.pageIndex, required this.selectTravelsIndex})
      : super(key: key);

  @override
  State<RecordFeedScreen> createState() => _RecordFeedScreenState();
}

Widget _buildAppBarWidget(String date) {
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
        children: [
          Text(
            date,
            style: const TextStyle(
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

class _RecordFeedScreenState extends State<RecordFeedScreen> {
  HomeViewModel _homeViewModel = HomeViewModel();
  RecordViewModel _recordViewModel = RecordViewModel();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _recordViewModel = Provider.of<RecordViewModel>(context, listen: false);

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.pageIndex);
    });
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * 340,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(UserColors.mainBackGround),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(22)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenUtil().statusBarHeight + ScreenUtil().setHeight(20),
            ),
            _buildAppBarWidget(widget.date),
            SizedBox(height: ScreenUtil().setHeight(10)),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _recordViewModel
                    .getRecordData.data?.data.travels[widget.selectTravelsIndex].records.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(32),
                            height: ScreenUtil().setHeight(32),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                _homeViewModel.getHomeData.data?.data.profile
                                        .userImage ??
                                    "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _recordViewModel.getRecordData.data?.data
                                        .travels[widget.selectTravelsIndex].title ??
                                    "",
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(UserColors.enable),
                                ),
                              ),
                              Text(
                                _recordViewModel
                                        .getRecordData
                                        .data
                                        ?.data
                                        .travels[widget.selectTravelsIndex]
                                        .records[index]
                                        .missionType ??
                                    "",
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8)),
                      // need add image here
                      Image.network(
                        _recordViewModel.getRecordData.data?.data.travels[widget.selectTravelsIndex]
                                .records[index].image ??
                            "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: ScreenUtil().setWidth(320),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8)),
                      Text(
                        _recordViewModel.getRecordData.data?.data.travels[widget.selectTravelsIndex]
                                .records[index].comment ??
                            "",
                        style: const TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(4),
                      ),
                      Text(
                        _recordViewModel.getRecordData.data?.data.travels[widget.selectTravelsIndex]
                                .records[index].uploadAt ??
                            "",
                        style: const TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(24)),
                      // listview end
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
