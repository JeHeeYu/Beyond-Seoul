import 'package:beyond_seoul/app.dart';
import 'package:beyond_seoul/network/api_url.dart';
import 'package:beyond_seoul/view/screens/error_screen.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:beyond_seoul/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../network/network_manager.dart';
import '../../routes/routes_name.dart';
import '../../statics/images.dart';
import '../../statics/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel _loginViewModel = LoginViewModel();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  void _writeStorage(String key, String result) async {
    await _storage.write(
      key: key,
      value: result,
    );
  }

  Future<void> _loginHandler(Map<String, dynamic> userData) async {
    try {
      await _loginViewModel.login(userData).then((_) {
        _writeStorage(
            Strings.uidKey, _loginViewModel.loginData.data?.data.id ?? '');
        _loginViewModel.setUid(_loginViewModel.loginData.data?.data.id ?? '');

        if (mounted) {
          if (_loginViewModel.loginData.data?.data.registerYN == 'Y') {
            _writeStorage(Strings.loginKey, "true");
            Navigator.of(context).pushReplacementNamed(RoutesName.app);
          } else {
            _writeStorage(Strings.loginKey, "false");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OnboardingScreen()));
          }
        }
      }).catchError((error) {
        _storage.deleteAll();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ErrorScreen()));
      });
    } catch (e) {
      if (mounted) {
        _writeStorage(Strings.uidKey, '');
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ErrorScreen()));
      }

      _storage.deleteAll();
    }
  }

  void googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    if (googleUser != null) {
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      Map<String, dynamic> userData = {
        "idToken": googleUser.id,
        "email": googleUser.email,
        "name": googleUser.displayName,
        "sns": "google",
      };

      _loginHandler(userData);
    } else {
      _writeStorage(Strings.loginKey, "false");
    }
  }

  void appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      Map<String, dynamic> userData = {
        "idToken": credential.userIdentifier,
        "email": credential.email,
        "name": '${credential.givenName} ${credential.familyName}',
        "sns": "apple",
      };

      _loginHandler(userData);
    } catch (error) {
      _writeStorage(Strings.loginKey, "false");
    }
  }

  void kakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');

        User user = await UserApi.instance.me();
        Map<String, dynamic> userData = {
          "idToken": user.id,
          "email": user.kakaoAccount?.email,
          "name": user.kakaoAccount?.profile?.nickname,
          "sns": "kakao",
        };

        _loginHandler(userData);
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          _writeStorage(Strings.loginKey, "false");
          return;
        }

        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');

          User user = await UserApi.instance.me();
          Map<String, dynamic> userData = {
            "idToken": user.id,
            "email": user.kakaoAccount?.email,
            "name": user.kakaoAccount?.profile?.nickname,
            "sns": "kakao",
          };

          _loginHandler(userData);
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          _writeStorage(Strings.loginKey, "false");
        }
      }
    } else {
      try {
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');

        User user = await UserApi.instance.me();
        Map<String, dynamic> userData = {
          "idToken": user.id,
          "email": user.kakaoAccount?.email,
          "name": user.kakaoAccount?.profile?.nickname,
          "sns": "kakao",
        };

        _loginHandler(userData);
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        _writeStorage(Strings.loginKey, "false");
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

      _loginHandler(userData);
    } else {
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ErrorScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(64)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenUtil().setHeight(64.0)),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    Strings.loginGuide1,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: Strings.loginGuide2,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: Strings.loginGuide3,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: ScreenUtil().setWidth(300.0),
                      height: ScreenUtil().setHeight(300.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Center(
                      child: Image.asset(Images.bgLogin,
                          width: ScreenUtil().setWidth(200.0),
                          height: ScreenUtil().setHeight(200.0)),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  // GestureDetector(
                  //   onTap: kakaoLogin,
                  //   child: Image.asset(Images.loginKakao),
                  // ),
                  // SizedBox(height: ScreenUtil().setHeight(16)),
                  // GestureDetector(
                  //   onTap: naverLogin,
                  //   child: Image.asset(Images.loginNaver),
                  // ),
                  // SizedBox(height: ScreenUtil().setHeight(16)),
                  GestureDetector(
                    onTap: googleLogin,
                    child: Image.asset(Images.loginGoogle),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(16)),
                  GestureDetector(
                      onTap: appleLogin, child: Image.asset(Images.loginApple)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
