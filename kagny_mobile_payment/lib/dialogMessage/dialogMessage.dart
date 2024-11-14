import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../home/homeClientPage.dart';
import '../yowpayUrlPage.dart';
import 'dialogBuilder.dart';

final Future<bool> _checkConnection = Connectivity().checkConnectivity() as Future<bool>;
class DialogMessage {
  const DialogMessage(this.context);
  final BuildContext context;

  _quitApp() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? urlDefault = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
    if (await localStorage.clear()){
      print(urlDefault.toString());
      await HomeClientPage().cookieManager?.clearCookies();
      //https://yowitweb-yowpay16-test-7143322.dev.odoo.com/web/session/logout?redirect=/
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const YowpayUrlPage()), (route) => false);
    }
  }

  Future<bool?> confirmPopPage(message) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
              title: Text(
                message,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: DialogButton(
                          child: Text('OUI', style: TextStyle(fontWeight: FontWeight.bold),),
                          color: Colors.red,
                          onPressed: () => Navigator.of(context).pop(true)
                      ),
                    ),
                    Container(
                      width: 100,
                      child: DialogButton(
                          child: Text('NON',style: TextStyle(fontWeight: FontWeight.bold),),
                          color: Colors.grey.withOpacity(0.2),
                          onPressed: () => Navigator.of(context).pop(false)
                      ),
                    )
                  ],
                )

              ]
          )
  );

  Future<bool?> confirmPopQuitPage(message) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
              title: Text(
                message,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: DialogButton(
                          child: const Text('OUI', style: TextStyle(fontWeight: FontWeight.bold),),
                          color: Colors.red,
                          onPressed: () => _quitApp()
                      ),
                    ),
                    Container(
                      width: 100,
                      child: DialogButton(
                          child: const Text('NON',style: TextStyle(fontWeight: FontWeight.bold),),
                          color: Colors.grey.withOpacity(0.2),
                          onPressed: () => Navigator.of(context).pop(false)
                      ),
                    )
                  ],
                )

              ]
          )
  );

  Future<bool?> confirmPopPageAvantQuitter(message) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
              title: Text(
                message,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: DialogButton(
                          child: Text('OK',style: TextStyle(fontWeight: FontWeight.bold),),
                          color: Colors.grey.withOpacity(0.2),
                          onPressed: () => Navigator.of(context).pop(false)
                      ),
                    )
                  ],
                )

              ]
          )
  );


}