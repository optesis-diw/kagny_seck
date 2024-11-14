import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kagny_mobile_payment/login/loginPage.dart';
import 'constants/constants.dart';
import 'constants/routesConstants.dart';
import 'demarragePage.dart';
import 'home/homeClientPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YowPay',
      debugShowCheckedModeBanner: false,
      color: Constants.PRIMARY_COLOR,
      theme: ThemeData(
        primaryColor: Constants.PRIMARY_COLOR,
      ),
      darkTheme: ThemeData.light(),
      home: const DemarragePage(),
      routes: <String, WidgetBuilder>{
        DEMARRAGE_PAGE: (BuildContext context) => const DemarragePage(),
        LOGIN_PAGE: (BuildContext context) => const LoginPage(),
        HOME_CLIENT_PAGE: (BuildContext context) => HomeClientPage(),
      },
    );
  }
}
