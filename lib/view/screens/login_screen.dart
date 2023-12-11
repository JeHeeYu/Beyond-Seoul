import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../statics/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void googleLogin() async {
    // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // final GoogleSignInAuthentication? googleAuth =
    //     await googleUser?.authentication;

    // final credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    // FirebaseAuth.instance.authStateChanges().listen((user) {
    //   if (user == null) {
    //   } else {}
    // });
  }

  void kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(64)),
          child: Column(
            children: [
              Expanded(child: Image.asset(Images.bgLogin)),
              GestureDetector(
                  onTap: () {
                    kakaoLogin();
                  },
                  child: Image.asset(Images.loginKakao)),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Image.asset(Images.loginNaver),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Image.asset(Images.loginGoogle),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Image.asset(Images.loginApple),
            ],
          ),
        ),
      ),
    );
  }
}
