import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutterprojet/yowpayUrlPage.dart';
import 'constants/constants.dart';
import 'dialogMessage/flushbarMessage.dart';
import 'home/homeClientPage.dart';

class DemarragePage extends StatefulWidget {
  const DemarragePage({super.key});

  @override
  DemarragePageState createState() => DemarragePageState();
}

class DemarragePageState extends State<DemarragePage>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    //await _testConnection(InternetConnectionChecker());
    var _duration = const Duration(seconds: 1);
    return Timer(_duration, _urlVerification);
  }

  Future<void> _testConnection(
      InternetConnectionChecker internetConnectionChecker) async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected == false && context.mounted) {
      FlushbarMessage(context)
          .ConnexionStatus("Veuilliez verifié votre connexion Internet", false);
    }

    final StreamSubscription<InternetConnectionStatus> _listenerConnection =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            FlushbarMessage(context)
                .ConnexionStatus("Connexion Internet établite", true);
            break;
          case InternetConnectionStatus.disconnected:
            FlushbarMessage(context).ConnexionStatus(
                "Veuillez verifié votre connexion Internet", false);
            break;
        }
      },
    );

    await Future<void>.delayed(const Duration(seconds: 30));
    await _listenerConnection.cancel();
  }

  _urlVerification() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var yowpayUrl = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
    if (yowpayUrl != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeClientPage(
                    urlDefault: yowpayUrl,
                  )),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const YowpayUrlPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
    //_urlVerification();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Constants.PRIMARY_COLOR,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage(
                Constants.IMGBG,
              ),
              fit: BoxFit.cover,
            )),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                  child: GFLoader(
                type: GFLoaderType.ios,
                size: GFSize.LARGE,
              )),
              SizedBox(
                height: 10,
              ),
              Text(
                'Kagny chargement...',
                style: TextStyle(
                    fontSize: 20,
                    color: Constants.PRIMARY_COLOR,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
