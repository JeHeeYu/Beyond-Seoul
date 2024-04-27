import 'dart:io';
import 'dart:typed_data';

import 'package:beyond_seoul/network/api_url.dart';
import 'package:beyond_seoul/network/network_manager.dart';
import 'package:beyond_seoul/statics/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../statics/images.dart';
import '../../statics/strings.dart';
import '../widgets/button_icon.dart';
import '../widgets/flexible_text.dart';
import '../widgets/infinity_button.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class MissionDetailScreen extends StatefulWidget {
  const MissionDetailScreen({
    Key? key,
    required this.title,
    required this.missionType,
    required this.missionId,
    required this.travelId,
  }) : super(key: key);

  final String title;
  final String missionType;
  final String missionId;
  final String travelId;

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  final _commentController = TextEditingController();
  XFile? uploadImage;
  final ImagePicker picker = ImagePicker();
  dynamic sendData;

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

    Map<String, String> data = {
      "missionType": widget.missionType,
      "missionId": widget.missionId,
      "recordComment": _commentController.text,
      "uid": "4",
      "travelId": widget.travelId
    };

    try {
      final response = await NetworkManager.instance
          .postInImage(ApiUrl.recordCreate, data, imageBytes);
      print('서버 응답: $response');
    } catch (error) {
      print("에러 발생: $error");
    }
  }

  void _refresh() {
    setState(() {
      uploadImage = null;
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

  Widget _buildMainContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(22)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
}
