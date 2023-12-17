import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../network/api_response.dart';
import '../../statics/colors.dart';
import '../../statics/strings.dart';
import '../../view_model/record_view_model.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  RecordViewModel recordViewModel = RecordViewModel();

  @override
  void initState() {
    super.initState();

    recordViewModel.fetchRecordImageApi();
  }

  String _getToday() {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy년MM월');
    String today = format.format(now);

    return today;
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

  Widget _buildCompleteWidget(RecordViewModel value) {
    return Column(
      children: [
        _buildDayWidget(),
      ],
    );
  }

  Widget _buildMainContent() {
    return ChangeNotifierProvider<RecordViewModel>(
      create: (BuildContext context) => recordViewModel,
      child: Consumer<RecordViewModel>(
        builder: (context, value, _) {
          switch (value.recordData.status) {
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return const Text("에러");
            case Status.complete:
              return _buildCompleteWidget(value);
            default:
              return const Text("오류");
          }
        },
      ),
    );
  }

  Widget _buildDayWidget() {
    return Row(
      children: [
        Text(
          _getToday(),
          style: const TextStyle(
            fontFamily: "Pretendard",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Icon(
          Icons.expand_more,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildImageWidget() {
    return Expanded(
      child: GridView.builder(
        itemCount: 25,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 110,
            height: 110,
            color: Colors.lightGreen,
            child: Text(' Item : $index'),
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
            _buildImageWidget(),
          ],
        ),
      ),
    );
  }
}
