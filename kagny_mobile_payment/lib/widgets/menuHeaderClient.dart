import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:kagny_mobile_payment/demarragePage.dart';
import 'package:kagny_mobile_payment/widgets/parametresPage.dart';

import '../constants/constants.dart';
import '../dialogMessage/dialogMessage.dart';
import '../dialogMessage/flushbarMessage.dart';
import '../home/homeClientPage.dart';
import '../yowpayUrlPage.dart';

class MenuHeaderClient extends StatefulWidget {
  const MenuHeaderClient(
    this.controller, {
    Key? key,
  }) : super(key: key);
  final Future<WebViewController> controller;

  @override
  _MenuHeaderClientState createState() => _MenuHeaderClientState();
}

class _MenuHeaderClientState extends State<MenuHeaderClient> {
  String nameClient = "Actualisation...";
  String namePartner = "Recuperation...";

  @override
  void initState() {
    _getNameClient();
    super.initState();
  }

  _getNameClient() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String recupNameClient =
        localStorage.getString(Constants.YOWPAY_CLIENT_NAME).toString();
    String recupNamePartner =
        localStorage.getString(Constants.YOWPAY_URL_DEFAULT).toString();
    setState(() {
      nameClient = recupNameClient;
      namePartner = recupNamePartner;
    });
  }

  confirmPopQuitPage(Future<WebViewController> controller) => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Vous allez deconnecter votre application de",
                textAlign: TextAlign.center,
              ),
              content: Text(
                namePartner,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Constants.PRIMARY_COLOR),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DialogButton(
                          child: const Text(
                            'OUI',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          color: Colors.red,
                          onPressed: () => _quitApp(controller, context)),
                    ),
                    SizedBox(
                      width: 100,
                      child: DialogButton(
                          child: const Text(
                            'NON',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          color: Colors.grey.withOpacity(0.2),
                          onPressed: () => Navigator.of(context).pop(false)),
                    )
                  ],
                )
              ]));

  _quitApp(Future<WebViewController> controller, BuildContext context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? urlDefault = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
    String url = urlDefault.toString() + "web/session/logout?redirect=/";
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse(url),
      method: WebViewRequestMethod.get,
    );
    await controller
        .then((value) => value.loadRequest(request)); //.loadRequest(request);
    if (await localStorage.clear()) {
      print(url.toString());
      await HomeClientPage().cookieManager?.clearCookies();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DemarragePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
        child: Scaffold(
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
            floatingActionButton: Container(
              width: size.width * 0.71,
              decoration: BoxDecoration(
                  color: Constants.PRIMARY_COLOR.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30)),
              margin: const EdgeInsets.only(right: 0, bottom: 0),
              padding: EdgeInsets.zero,
              child: MaterialButton(
                  onPressed: () {
                    confirmPopQuitPage(widget.controller);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.exit_to_app,
                          size: 22,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Changer d\'organisation',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ])),
            ),
            body: SizedBox(
              height: size.height,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 65),
                        child: GFListTile(
                          //icon: const Icon(Icons.edit),
                          avatar: GFAvatar(
                            size: 40,
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            child: const Icon(
                              Icons.person,
                              size: 34,
                              color: Constants.PRIMARY_COLOR,
                            ),
                          ),
                          title: SizedBox(
                              height: 30,
                              width: 160,
                              child: Text(
                                nameClient,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                          //subTitleText:'Modifier le profil',
                          onTap: () {},
                          //icon: Icon(Icons.favorite)
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      /*ListTile(
                leading: const Icon(Icons.history, color: Constants.PRIMARY_COLOR, size: 32,),
                title: const Text('Vos Factures', style: TextStyle(fontSize: 16),),
                onTap: (){
                  FlushbarMessage(context).EnConstructionMessage('Vos factures est en cours d\'implementation');
                },
                subtitle: const Text("Historique de vos factures"),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Constants.PRIMARY_COLOR, size: 32,),
                title: const Text('Notification', style: TextStyle(fontSize: 16),),
                onTap: (){
                  FlushbarMessage(context).EnConstructionMessage('Notification en cours d\'implementation');
                },
                subtitle: const Text("Vos retours de messages"),
              ), */

                      ListTile(
                        leading: const Icon(
                          Icons.message_outlined,
                          color: Constants.PRIMARY_COLOR,
                          size: 32,
                        ),
                        title: const Text(
                          'Aide',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          FlushbarMessage(context).EnConstructionMessage(
                              'Aide en cours d\'implementation');
                        },
                        subtitle: const Text("Vos avez besion d'aide?"),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.help_outline,
                          color: Constants.PRIMARY_COLOR,
                          size: 32,
                        ),
                        title: const Text(
                          'À propos',
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          FlushbarMessage(context).EnConstructionMessage(
                              'A propos en cours d\'implementation');
                        },
                        subtitle: const Text("Qui sommes nous"),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.lock_outline,
                          color: Constants.PRIMARY_COLOR,
                          size: 32,
                        ),
                        title: const Text(
                          "Parametres",
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ParametresPage()));
                        },
                        subtitle: const Text("Activez le vérrouillage ?"),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }
}
