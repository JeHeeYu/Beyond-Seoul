import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../statics/colors.dart';
import '../../statics/strings.dart';

class RecordFeedScreen extends StatefulWidget {
  final String date;

  const RecordFeedScreen({Key? key, required this.date}) : super(key: key);

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
                itemCount: 4,
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
                                "https://mediahub.seoul.go.kr/wp-content/uploads/2020/03/53552dfe5d897d0a50138605f19628a6.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "해운대에서",
                                style: const TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(UserColors.enable),
                                ),
                              ),
                              Text(
                                "개인 미션",
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
                        "https://mediahub.seoul.go.kr/wp-content/uploads/2020/03/53552dfe5d897d0a50138605f19628a6.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: ScreenUtil().setWidth(320),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(8)),
                      Text(
                        "it was amazing!",
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
                        "2023.11.10",
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
