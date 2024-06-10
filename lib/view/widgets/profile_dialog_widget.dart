import 'dart:io';
import 'package:beyond_seoul/view/widgets/infinity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

import '../../statics/colors.dart';
import '../../statics/strings.dart';
import '../../view_model/home_view_model.dart';
import '../../view_model/login_view_model.dart';

class ProfileDialogWidget {
  static int _calculateAge(String birthDateStr) {
    try {
      final birthDate = DateTime.parse(birthDateStr);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  static Future<void> show(BuildContext context, HomeViewModel homeViewModel,
      LoginViewModel loginViewModel) async {
    final TextEditingController genderController = TextEditingController(
        text: loginViewModel.loginData.data?.data.sex ?? '');
    final TextEditingController birthController = TextEditingController(
        text: _calculateAge(loginViewModel.loginData.data?.data.birth ?? '')
            .toString());

    final picker = ImagePicker();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _ProfileDialogContent(
          homeViewModel: homeViewModel,
          loginViewModel: loginViewModel,
          genderController: genderController,
          birthController: birthController,
          picker: picker,
        );
      },
    );
  }
}

class _ProfileDialogContent extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final LoginViewModel loginViewModel;
  final TextEditingController genderController;
  final TextEditingController birthController;
  final ImagePicker picker;

  const _ProfileDialogContent({
    Key? key,
    required this.homeViewModel,
    required this.loginViewModel,
    required this.genderController,
    required this.birthController,
    required this.picker,
  }) : super(key: key);

  @override
  __ProfileDialogContentState createState() => __ProfileDialogContentState();
}

class __ProfileDialogContentState extends State<_ProfileDialogContent> {
  XFile? selectedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await widget.picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  void _sendProfileEdit() async {
    String uid = widget.loginViewModel.getUid;
    String sex = widget.genderController.text;
    String nickname = widget.loginViewModel.loginData.data?.data.nickName ?? '';
    String birth = widget.loginViewModel.loginData.data?.data.birth ?? '';
    File? imageFile;

    if (selectedImage != null) {
      imageFile = File(selectedImage!.path);
    }

    Map<String, dynamic> data = {
      "uid": uid,
      "sex": sex,
      "nickname": nickname,
      "birth": birth,
    };

    if (imageFile != null) {
      data["image"] = await MultipartFile.fromFile(imageFile.path,
          filename: "profile_image.png",
          contentType: MediaType("image", "png"));
    }

    await widget.loginViewModel.edit(data);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: SizedBox(
          width: ScreenUtil().setWidth(294),
          height: ScreenUtil().setHeight(431),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: ScreenUtil().setHeight(10)),
              Text(
                widget.loginViewModel.loginData.data?.data.nickName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Pretendard",
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(25)),
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: selectedImage != null
                              ? Image.file(
                                  File(selectedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.homeViewModel.getHomeData.data?.data
                                          .profile.userImage ??
                                      '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, size: 50);
                                  },
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(17)),
                    Text(
                      widget.loginViewModel.loginData.data?.data.email ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(UserColors.disable),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(22)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            Strings.gender,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: const Color(UserColors.disable)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: widget.genderController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[가-힣]')),
                                  LengthLimitingTextInputFormatter(1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            Strings.birthday,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(80),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: const Color(UserColors.disable)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: widget.birthController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              GestureDetector(
                onTap: _sendProfileEdit,
                child: InfinityButton(
                  height: ScreenUtil().setHeight(32),
                  radius: 4,
                  backgroundColor: const Color(UserColors.enable),
                  text: Strings.editComplete,
                  textSize: 13,
                  textWeight: FontWeight.w700,
                  textColor: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: InfinityButton(
                  height: ScreenUtil().setHeight(32),
                  radius: 4,
                  backgroundColor: const Color(UserColors.disable),
                  text: Strings.close,
                  textSize: 13,
                  textWeight: FontWeight.w700,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
