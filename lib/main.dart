import 'package:beyond_seoul/routes/routes.dart';
import 'package:beyond_seoul/routes/routes_name.dart';
import 'package:beyond_seoul/utils/app_key.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/login_screen.dart';
import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:beyond_seoul/view_model/home_view_model.dart';
import 'package:beyond_seoul/view_model/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: AppKey.kakaoNaviteKey);

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => RecordViewModel()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 840),
        builder: (BuildContext context, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          //home: const OnboardingScreen(),
          home: const App(),
        ),
      ),
    );
  }
}
