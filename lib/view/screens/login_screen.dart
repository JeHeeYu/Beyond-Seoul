import 'package:beyond_seoul/app.dart';
import 'package:beyond_seoul/network/api_url.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:beyond_seoul/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../network/network_manager.dart';
import '../../statics/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel _loginViewModel = LoginViewModel();

  @override
  void initState() {
    super.initState();

    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  void googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');
    }
  }

  void kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();

        print('카카오계정으로 로그인 성공');
        User user = await UserApi.instance.me();
        print('\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');

        Map<String, dynamic> jsonData = {
          'email': user.kakaoAccount?.email,
          'idToken': user.id,
          'nickName': user.kakaoAccount?.profile?.nickname,
          'sns': 'kakao',
        };

        //_loginViewModel.login(jsonData);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void naverLogin() async {
    final NaverLoginResult result = await FlutterNaverLogin.logIn();

    if (result.status == NaverLoginStatus.loggedIn) {
      print('accessToken = ${result.accessToken}');
      print('id = ${result.account.id}');
      print('email = ${result.account.email}');
      print('name = ${result.account.name}');

      Map<String, dynamic> userData = {
        "idToken": result.account.id,
        "email": result.account.email,
        "name": result.account.name,
        "sns": "naver",
      };

      Uint8List? thumbnailData = await loadImageAsset(Images.bgLogin);

      try {
        await _loginViewModel.login(userData, thumbnailData);

        print("Jehee : ${_loginViewModel.loginData.data?.data.id}");

        if (_loginViewModel.loginData.data?.data.registerYN == 'Y') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const App()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      } catch (e) {
        print("Error calling imagePost: $e");
      }
    } else {
      print('Login failed: ${result.status}');
    }
  }

  Future<Uint8List> loadImageAsset(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
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
              GestureDetector(
                  onTap: () {
                    naverLogin();
                  },
                  child: Image.asset(Images.loginNaver)),
              SizedBox(height: ScreenUtil().setHeight(16)),
              GestureDetector(
                  onTap: () {
                    googleLogin();
                  },
                  child: Image.asset(Images.loginGoogle)),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Image.asset(Images.loginApple),
            ],
          ),
        ),
      ),
    );
  }
}
