import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testflutterprojet/demarragePage.dart';
import 'package:testflutterprojet/home/homeClientPage.dart';
import '../constants/constants.dart';

class FormPaymentPage extends StatefulWidget {
  FormPaymentPage({Key? key, this.urlFormPayment}) : super(key: key);
  late String? urlFormPayment;
  @override
  _FormPaymentPageState createState() => _FormPaymentPageState();
}

class _FormPaymentPageState extends State<FormPaymentPage> {
  bool minMontant = false;
  String value = "7";

  _createValue(String newValue) {
    setState(() {
      if (value.length < 9) {
        if (value.length == 0 && newValue == "0") {
          value = "7";
        } else {
          value = value + newValue;
          if (value.length == 9) {
            value = value.substring(0, 2) +
                " " +
                value.substring(2, 5) +
                " " +
                value.substring(5, 7) +
                " " +
                value.substring(7, 9);
          }
        }
      } else {
        GFToast.showToast("Numéro $value", context,
            backgroundColor: Colors.red);
      }

      print("newvalue $newValue");
    });
  }

  _deleteValue() {
    setState(() {
      int t = value.length;
      if (t <= 1) {
        value = "7";
      } else {
        value = value.substring(0, t - 1);
        if (value.length < 11) {
          value = value.replaceAll(RegExp(r" "), "");
        }
      }
      print("newvalue $value");
    });
  }

  _reinitValue() {
    setState(() {
      value = "7";
    });
  }

  _validerNumero(String typePaiment) {
    String numeroPayment = value.replaceAll(RegExp(r" "), "");
    if (numeroPayment.length <= 8) {
      GFToast.showToast(
          "$numeroPayment incorrect veuillez saisir votre numéro téléphone de recharge",
          context,
          backgroundColor: Colors.red);
    } else {
      print(numeroPayment);
      if (typePaiment.toUpperCase() == "WAVE") {
        //Navigator.push(context, MaterialPageRoute(
        //    builder: (context) => WaveRechargePage(value)));
      } else {
        _rechargeOmCodeOtp();
      }
    }
  }

  _rechargeOmCodeOtp() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => BottomSheetRechargeOmCodeOtpClient(
            value, widget.urlFormPayment.toString()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DemarragePage()),
              (route) => false);
          //return popApp ?? false;
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.PRIMARY_COLOR,
              title: const Text('YowPay'),
              centerTitle: true,
            ),
            body: SizedBox(
                height: size.height * 1,
                child: Column(
                  children: [
                    Container(
                      //padding: const EdgeInsets.only(top: 50),
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        "Entrez votre numéro orange money\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 70,
                      width: size.width * 0.8,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.PRIMARY_COLOR.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //SizedBox(height: 5,),
                          Text(
                            value.length == 1 ? "7- --- -- --" : value,
                            style: const TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      height: size.height * 0.45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "1",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("1");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "2",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("2");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "3",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("3");
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "4",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("4");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "5",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("5");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "6",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("6");
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "7",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("7");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "8",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("8");
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "9",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("9");
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              DialogButton(
                                  color:
                                      Constants.PRIMARY_COLOR.withOpacity(0.1),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  height: 60,
                                  child: const Icon(
                                    Icons.autorenew,
                                    color: Constants.PRIMARY_COLOR,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    _reinitValue();
                                  }),
                              DialogButton(
                                  color: Constants.PRIMARY_COLOR.withOpacity(0),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: Constants.PRIMARY_COLOR,
                                          width: 2,
                                          style: BorderStyle.solid)),
                                  height: 60,
                                  child: const Text(
                                    "0",
                                    style: TextStyle(
                                        color: Constants.PRIMARY_COLOR,
                                        fontSize: 38,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _createValue("0");
                                  }),
                              DialogButton(
                                  color:
                                      Constants.PRIMARY_COLOR.withOpacity(0.1),
                                  width: 60,
                                  radius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  height: 60,
                                  child: const Icon(
                                    Icons.backspace,
                                    color: Constants.PRIMARY_COLOR,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    _deleteValue();
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /*DialogButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          height: 60,
                          width: 150,
                          child: GFImageOverlay(
                            image: const AssetImage("assets/images/wm.png"),
                            height: 60,
                            //width: 50,
                            boxFit: BoxFit.fill,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            //Navigator.pop(context);
                            _validerNumero("WAVE");
                          }
                      ), */
                        DialogButton(
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            height: 60,
                            width: 150,
                            child: GFImageOverlay(
                              image: const AssetImage("assets/images/om.jpg"),
                              height: 60,
                              //width: 50,
                              boxFit: BoxFit.fill,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {
                              //Navigator.pop(context);
                              _validerNumero("Orange Money");
                            })
                      ],
                    )
                  ],
                ))));
  }
}

class BottomSheetRechargeOmCodeOtpClient extends StatefulWidget {
  const BottomSheetRechargeOmCodeOtpClient(this.numeroOm, this.urlBase,
      {Key? key})
      : super(key: key);
  final numeroOm;
  final String urlBase;

  @override
  _BottomSheetRechargeOmCodeOtpClientState createState() =>
      _BottomSheetRechargeOmCodeOtpClientState();
}

class _BottomSheetRechargeOmCodeOtpClientState
    extends State<BottomSheetRechargeOmCodeOtpClient> {
  String value = "";

  _createValue(String newValue) {
    setState(() {
      if (value.length < 6) {
        value = value + newValue;
      } else {
        GFToast.showToast("Code $value", context, backgroundColor: Colors.red);
      }
      print("newvalue $newValue");
    });
  }

  _deleteValue() {
    setState(() {
      int t = value.length;
      if (t <= 1) {
        value = "";
      } else {
        value = value.substring(0, t - 1);
      }
      print("newvalue $value");
    });
  }

  _reinitValue() {
    setState(() {
      value = "";
    });
  }

  _validerCode() async {
    if (value.length != 6) {
      GFToast.showToast(
          "code $value incorrect veuillez saisir un code valide généré en tapant #144#391#",
          context,
          backgroundColor: Colors.red);
    } else {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? defaultUrl = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
      if (defaultUrl != null) {
        String numero = widget.numeroOm.toString().trim().replaceAll(" ", "");
        String code = value.toString();
        String urlPayment = defaultUrl +
            "payment/ypay/data/app/form?numero=" +
            numero +
            "&code=" +
            code;
        print("______________url_payment_________: $urlPayment");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeClientPage(
                      numeroPayment:
                          widget.numeroOm.toString().trim().replaceAll(" ", ""),
                      code: value,
                      urlPayment: urlPayment,
                    )),
            (route) => false); //, value)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: SizedBox(
            height: size.height * 0.9,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(children: [
                      Text(
                        "Entrez votre code temporaire de paiement généré sur ${widget.numeroOm.toString()} en tapant",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "#144#391#",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ])),
                Container(
                  height: 70,
                  width: size.width * 0.8,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.PRIMARY_COLOR.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //SizedBox(height: 5,),
                      Text(
                        value.isEmpty ? "------" : value,
                        style: const TextStyle(
                            color: Constants.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.45,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "1",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("1");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "2",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("2");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "3",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("3");
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "4",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("4");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "5",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("5");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "6",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("6");
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "7",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("7");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "8",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("8");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "9",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("9");
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0.1),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              height: 60,
                              child: const Icon(
                                Icons.autorenew,
                                color: Constants.PRIMARY_COLOR,
                                size: 32,
                              ),
                              onPressed: () {
                                _reinitValue();
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: const Border.fromBorderSide(BorderSide(
                                  color: Constants.PRIMARY_COLOR,
                                  width: 2,
                                  style: BorderStyle.solid)),
                              height: 60,
                              child: const Text(
                                "0",
                                style: TextStyle(
                                    color: Constants.PRIMARY_COLOR,
                                    fontSize: 38,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                _createValue("0");
                              }),
                          DialogButton(
                              color: Constants.PRIMARY_COLOR.withOpacity(0.1),
                              width: 60,
                              radius:
                                  const BorderRadius.all(Radius.circular(50)),
                              height: 60,
                              child: const Icon(
                                Icons.backspace,
                                color: Constants.PRIMARY_COLOR,
                                size: 28,
                              ),
                              onPressed: () {
                                _deleteValue();
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DialogButton(
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        height: 60,
                        width: 150,
                        child: GFImageOverlay(
                          image: const AssetImage("assets/images/om.jpg"),
                          height: 60,
                          //width: 50,
                          boxFit: BoxFit.fill,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _validerCode();
                        })
                  ],
                )
              ],
            )));
  }
}
