import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:testflutterprojet/demarragePage.dart';
import 'package:testflutterprojet/errors/error404.dart';
import 'package:testflutterprojet/payment/formPayment.dart';
import '../constants/constants.dart';
import '../widgets/menuHeaderClient.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePaymentPage extends StatefulWidget {
  HomePaymentPage(
      {Key? key,
      required this.numeroPayment,
      required this.code,
      required this.urlPayment,
      this.cookieManager})
      : super(key: key);

  final CookieManager? cookieManager;
  late String numeroPayment;
  late String code;
  late String urlPayment;

  @override
  State<HomePaymentPage> createState() => _WebViewHomePaymentPageState();
}

class _WebViewHomePaymentPageState extends State<HomePaymentPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  Future<void> _launchUrlDownload(url, context) async {
    Uri _url = Uri.parse(url);

    if (await canLaunchUrl(_url)) {
      launchUrl(_url, mode: LaunchMode.externalApplication);
    } else {
      _errorUrlDownload(context, 'Telechargement facture non disponoble');
    }
  }

  Future<void> _launchUrlPrint(context) async {
    _errorUrlDownload(context, 'impression facture non disponoble');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Constants.PRIMARY_COLOR, // Colors.blue,
      appBar: AppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        title: const Text('Ypay'),
        centerTitle: true,
      ),
      /*bottomNavigationBar: ConvexAppBar(
        backgroundColor: Constants.PRIMARY_COLOR,
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.arrow_back_ios),
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.arrow_forward_ios),
        ],
        initialActiveIndex: 1,
        onTap: (int i) => {
          if (i == 0){
            _goBackPage(_controller.future),
          }else if(i == 1){
            _reloadPage(_controller.future),
          }else if (i == 2){
            _goForwardPage(_controller.future),
          }else{
            print("______________0FF_______________")
          }
        },
      ),*/
      body: WebView(
        initialUrl: "${widget.urlPayment}payment/ypay/data/app/form?numero=${widget.numeroPayment}&code=${widget
                .code}", //'https://yowitweb-ypay-ypay-test-6591479.dev.odoo.com/',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onWebResourceError: (WebResourceError error) {
          const Center(
              child: SizedBox(
                  width: 240,
                  height: 400,
                  child: Text(
                    "ERREUR",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  )));
          return _error404(context, _controller.future);
          //return _errorUrl(context, _controller.future);
        },
        onProgress: (int progress) {
          setState(() {
            _onProgressUrl(context, progress);
          });
          print('_______________WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        onPageStarted: (String url) {
          const Center(
              child: Text(
            "Chargement en cours...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.red),
          ));
        },
        onPageFinished: (String url) {
          const Center(
              child: Text(
            "Chargement Terminer",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ));
          print('_______________Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
        navigationDelegate: (NavigationRequest request) {
          if (request.url.contains("report_type=pdf&download=true")) {
            _launchUrlDownload(request.url, context);
            return NavigationDecision.prevent; //.prevent;
          }
          if (request.url.contains("report_type=pdf")) {
            _launchUrlPrint(context);
            return NavigationDecision.prevent; //.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),

      //floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

_error404(BuildContext context, Future<WebViewController> controllerUrl) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Error404Page(controller: controllerUrl)),
      (route) => false);
}

_errorUrlDownload(context, message) {
  Alert(
      context: context,
      title: message.toString(),
      type: AlertType.warning,
      //desc: "Veuillez reessayer plus tard",
      onWillPopActive: true,
      closeIcon: const Icon(
        Icons.sync,
        color: Colors.white,
      ),
      content: Column(
        children: const <Widget>[],
      ),
      buttons: [
        DialogButton(
          child: const Text(
            "Retour",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Constants.PRIMARY_COLOR,
        ),
      ]).show();
}

_onProgressUrl(context, progress) {
  return const Center(child: GFLoader(type: GFLoaderType.ios));
}

_reloadPage(Future<WebViewController> _webViewControllerFuture) {
  _webViewControllerFuture.then((controller) async => {
        await controller.reload(),
      });
}

_goBackPage(Future<WebViewController> _webViewControllerFuture) {
  _webViewControllerFuture.then((controller) async => {
        await controller.goBack(),
      });
}

_goForwardPage(Future<WebViewController> _webViewControllerFuture) {
  _webViewControllerFuture.then((controller) async => {
        await controller.goForward(),
      });
}
