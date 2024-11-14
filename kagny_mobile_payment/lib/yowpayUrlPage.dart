import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:getwidget/components/toast/gf_toast.dart";
import 'package:kagny_mobile_payment/home/homeClientPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kagny_mobile_payment/demarragePage.dart';

import '../constants/constants.dart';

class YowpayUrlPage extends StatefulWidget {
  const YowpayUrlPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _YowpayUrlPageState();
}

class _YowpayUrlPageState extends State<YowpayUrlPage> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final urlDefault = "";

  @override
  void dispose() {
    _nameController.clear();
    _urlController.clear();
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  _saveUrl(String url, String name) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (!url.endsWith('/')) {
      url = url + '/';
    }
    if (await localStorage.setString(Constants.YOWPAY_URL_DEFAULT, url)) {
      await localStorage.setString(Constants.YOWPAY_CLIENT_NAME, name);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeClientPage(
                    urlDefault: url,
                  )),
          (route) => false);
    } else {
      GFToast.showToast(
          "Une erreur s'est produite, veuillez nous contacter contact@yowpay.net",
          context,
          backgroundColor: Colors.grey.shade300,
          textStyle: const TextStyle(
              color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.share, title: "Partager"), //.arrow_back_ios),
          TabItem(icon: Icons.home),
          TabItem(
              icon: Icons.info_outline, title: "Infos") //.arrow_forward_ios),
        ],
        initialActiveIndex: 1,
        onTap: (int i) => {
          if (i == 0)
            {}
          else if (i == 1)
            {
              print("______________reload_______________"),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DemarragePage())),
            }
          else if (i == 2)
            {}
        },
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Constants.PRIMARY_COLOR,
          ),
          Form(
            child: Positioned(
              top: MediaQuery.of(context).size.height * 0.14,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Constants.whiteshade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.72,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.12),
                      child: Image.asset(Constants.YOWPAY_LOGO),
                    ),
                    const Center(
                      child: Text(
                        "Veuillez saisir l'url de votre organisaton pour commencer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constants.PRIMARY_COLOR, fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: Constants.grayshade.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: _urlController,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          //labelText: 'Votre Numéro',
                          //label: Text('Collez l\'url de votre organisation',
                          //style: TextStyle(
                          //color: Constants.PRIMARY_COLOR,
                          //  fontSize: 18
                          //),
                          //),
                          hintText: "https://kagnytechnology.com",
                          //hintText: "https://xxxxxx.yowpay.net",
                          //prefixText: '+221',
                          //border: OutlineInputBorder(),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.web,
                            color: Constants.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      decoration: BoxDecoration(
                          color: Constants.grayshade.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: _nameController,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Votre Nom",
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: Constants.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        print(_urlController.text);
                        if (_urlController.text == "") {
                          GFToast.showToast(
                              "Veuillez saisir l'url de votre organisation",
                              context,
                              backgroundColor: Colors.grey.shade300,
                              textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold));
                        } else if (!_urlController.text
                            .toString()
                            .contains("https://")) {
                          GFToast.showToast(
                              "Votre url doit etre du format : https://kagnytechnology.com",
                              context,
                              backgroundColor: Colors.grey.shade300,
                              textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold));
                        } else if (_nameController.text.toString().length < 5) {
                          GFToast.showToast(
                              "Veuillez saisir votre nom", context,
                              backgroundColor: Colors.grey.shade300,
                              textStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold));
                        } else {
                          _saveUrl(_urlController.text.toString(),
                              _nameController.text.toString());
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.07,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        decoration: const BoxDecoration(
                            color: Constants.PRIMARY_COLOR,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Center(
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Constants.whiteshade),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.149,
                          top: MediaQuery.of(context).size.height * 0.08),
                      child: Text.rich(
                        TextSpan(
                            text: "Vous avez besoin d'aide? ",
                            style: TextStyle(
                                color: Constants.grayshade.withOpacity(0.8),
                                fontSize: 16),
                            children: [
                              TextSpan(
                                  text: "Assistance",
                                  style: const TextStyle(
                                      color: Constants.PRIMARY_COLOR,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print("assistance");
                                      //Navigator.pushReplacement(
                                      //  context,
                                      //MaterialPageRoute(
                                      //  builder: (context) => HomeClientPage()));
                                    }),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

_rechargeOmCodeOtp(context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _BottomSheetInfoClient());
}

class _BottomSheetInfoClient extends StatelessWidget {
  const _BottomSheetInfoClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
