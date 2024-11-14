import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:testflutterprojet/demarragePage.dart';
import 'package:testflutterprojet/home/homeClientPage.dart';
import '../constants/constants.dart';


class Error404Page extends StatefulWidget {
  const Error404Page({Key? key, required this.controller}) : super(key: key);
  final Future<WebViewController> controller;
  @override
  State<Error404Page> createState() => _Error404PageState();
}

class _Error404PageState extends State<Error404Page> {


  @override
  void initState() {
    super.initState();
  }

  _reloadPage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const DemarragePage()), (route)=>false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async{
         var popApp = true;

         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const DemarragePage()), (route)=>false);

          return popApp;
    },
     child: Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        title: const Text('Yowpay'),
        centerTitle: true,
      ),
       bottomNavigationBar: ConvexAppBar(
         backgroundColor: Constants.PRIMARY_COLOR,
         style: TabStyle.fixedCircle,
         items: const [
           TabItem(icon: Icons.arrow_back_ios),
           TabItem(icon: Icons.home),
           TabItem(icon: Icons.arrow_forward_ios),
         ],
         initialActiveIndex: 1,
         onTap: (int i) => {
             _reloadPage()
         },
       ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CONNEXION IMPOSSIBLE\n",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              const Text(
                "Veuillez vérifié votre connexion internet et reesayer ou contacter nous si le probleme persiste\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Constants.PRIMARY_COLOR,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              DialogButton(
                onPressed: () {

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const DemarragePage()), (route)=>false);

                },
                child: const Text(
                  "Réessayer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),),
                color: Colors.red,
              )
            ],
          )
        ],
      ),

     )
    );
  }
}

_reloadPage(){

}
