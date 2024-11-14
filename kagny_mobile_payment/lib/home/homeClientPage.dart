import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
import 'package:getwidget/getwidget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kagny_mobile_payment/demarragePage.dart';
import 'package:kagny_mobile_payment/errors/error404.dart';
import 'package:kagny_mobile_payment/payment/formPayment.dart';
import '../constants/constants.dart';
import '../dialogMessage/flushbarMessage.dart';
import '../widgets/menuHeaderClient.dart';

import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/parametresPage.dart';

class HomeClientPage extends StatefulWidget {
  HomeClientPage(
      {Key? key,
      this.numeroPayment,
      this.code,
      this.urlPayment,
      this.cookieManager,
      this.urlDefault})
      : super(key: key);

  final CookieManager? cookieManager;
  late String? numeroPayment;

  late String? code;
  late String? urlPayment;
  late String? urlDefault;

  @override
  State<HomeClientPage> createState() => _WebViewHomeClientPageState();
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class _WebViewHomeClientPageState extends State<HomeClientPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  //bool? _canCheckBiometrics;
  //List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  //late final WebViewController _controllerPayment;
  //String? defaultUrl = "";//'https://www.yowpay.net/';
  @override
  void initState() {
    super.initState();
    initialization();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  void initialization() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      widget.urlDefault = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
    });
    auth.isDeviceSupported().then((bool isSupported) {
      if (isSupported) {
        bool? isUserWantAuth =
            localStorage.getBool(Constants.IS_USER_WANT_AUTH);
        if (isUserWantAuth == true) {
          setState(() {
            _authenticate();
          });
        }
      }
      //setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Déverrouiller Kagny',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
              signInTitle: 'Déverrouiller Kagny',
              deviceCredentialsRequiredTitle:
                  "Méthode de déverrouillage absente",
              deviceCredentialsSetupDescription:
                  "Voullez vous ajouter une méthode de déverrouillage?",
              goToSettingsDescription:
                  "Ajouter une méthode de déverrouillage par empreinte digitale pour sécuriser facilement votre compte\nVous pouvez désactiver cette fenêtre sur votre profil",
              goToSettingsButton: "Aller aux parametres",
              //biometricHint: "Toucher le capteur d'empreinte digitale",
              biometricNotRecognized: "Empreinte digitale non reconnue",
              biometricRequiredTitle: "Kagny Sécurité",
              //cancelButton: 'Ignorer',
              biometricSuccess: "Authentification avec succès"),
          IOSAuthMessages(
            lockOut:
                "Voullez vous activer la méthode de déverrouillage par empreinte digitale ",
            localizedFallbackTitle: "Déverrouiller Kagny",
            //cancelButton: 'Ignorer',
            goToSettingsButton: "Aller aux parametres",
            goToSettingsDescription:
                "Ajouter une méthode de déverrouillage par empreinte digitale pour sécuriser facilement votre compte",
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _launchUrlWave(url, context) async {
    Uri _url = Uri.parse(url);

    if (await canLaunchUrl(_url)) {
      launchUrl(_url, mode: LaunchMode.externalApplication);
    } else {
      _errorUrlDownload(context, 'Telechargement facture non disponible');
    }
  }

  Future<void> _launchUrlDownload(url, context) async {
    Uri _url = Uri.parse(url);

    if (await canLaunchUrl(_url)) {
      launchUrl(_url, mode: LaunchMode.externalApplication);
    } else {
      _errorUrlDownload(context, 'Telechargement facture non disponible');
    }
  }

  Future<void> _launchUrlPrint(context) async {
    _errorUrlDownload(context, 'impression facture non disponible');
  }

  @override
  Widget build(BuildContext context) {
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
          //backgroundColor: Constants.PRIMARY_COLOR, // Colors.blue,
          appBar: AppBar(
            backgroundColor: Constants.PRIMARY_COLOR,
            title: const Text('Kagny'),
            centerTitle: true,
            //actions: <Widget>[
            //NavigationControls(_controller.future),
            //SampleMenu(_controller.future, widget.cookieManager),
            //],
          ),
          drawer: MenuHeaderClient(_controller.future),
          bottomNavigationBar: bottomBar(),
          body: WebView(
            initialUrl: widget.urlPayment ?? widget.urlDefault,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              print("_____________cookies______________");
              print(widget.cookieManager.toString());
              print("_____________cookies______________");
              //_controllerPayment = webViewController;
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
              print("_____________________error____________________");
              print(error.errorCode.toString());
              print("_____________________eroor____________________");
              return _error404(context, _controller.future);
            },
            onProgress: (int progress) {
              GFToast.showToast("chargement: $progress%", context,
                  toastDuration: 3, toastPosition: GFToastPosition.TOP);
              const Center(
                child: CircularProgressIndicator(),
              );
              print(
                  '_______________WebView is loading (progress : $progress%)');
            },
            javascriptChannels: <JavascriptChannel>{
              _toasterJavascriptChannel(context),
            },
            onPageStarted: (String url) {
              print('________________page loading: $url __________________');
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
              print(
                  '_______________Page finished loading: $url ______________');
            },
            gestureNavigationEnabled: true,
            backgroundColor: const Color(0x00000000),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains(Constants.URL_WAVE_REDIRECT)) {
                _launchUrlWave(request.url, context);
                return NavigationDecision.prevent;
              }
              if (request.url.contains(Constants.URL_DOC_DONWLOAD)) {
                _launchUrlDownload(request.url, context);
                return NavigationDecision.prevent; //.prevent;
              }
              if (request.url.contains(Constants.URL_DOC_PRINT)) {
                _launchUrlPrint(context);
                return NavigationDecision.prevent; //.prevent;
              }
              if (request.url.contains(Constants.URL_OM_REDIRECT)) {
                print("_________________form________________");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormPaymentPage(
                              urlFormPayment: widget.urlDefault,
                            )));
                //return NavigationDecision.prevent;
              }

              if (widget.numeroPayment != null && widget.code != null) {
                String numero = widget.numeroPayment.toString();
                String code = widget.code.toString();
                print(
                    "___________________payment________________$numero et $code");
                //var redirUrl = defaultUrl + "payment/ypay/data/app/form?numero="+numero+"&code="+code;
                //Navigator.push(context, MaterialPageRoute(
                //   builder: (context) =>  HomePaymentPage(numeroPayment: numero, code: code, urlPayment: redirUrl)));
                // _loadUrlPayment(_controller.future, redirUrl);
              }
              return NavigationDecision.navigate;
            },
          ),
          //floatingActionButton: favoriteButton(),
        ));
  }

  Widget bottomBar() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return controller.hasData
              ? ConvexAppBar(
                  backgroundColor: Constants.PRIMARY_COLOR,
                  style: TabStyle.reactCircle,
                  items: const [
                    TabItem(icon: Icons.sync), //.arrow_back_ios),
                    TabItem(icon: Icons.home),
                    TabItem(icon: Icons.info_outline) //.arrow_forward_ios),
                  ],
                  initialActiveIndex: 1,
                  onTap: (int i) => {
                    if (i == 0)
                      {
                        _goBackPage(_controller.future),
                      }
                    else if (i == 1)
                      {
                        setState(() {
                          widget.urlPayment = null;
                        }),
                        _reloadPage(_controller.future),
                      }
                    else if (i == 2)
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ParametresPage()))
                        //_showUrl(context, controller),
                        //_goForwardPage(_controller.future),
                      }
                    else
                      {print("______________0FF_______________")}
                  },
                )
              : const CircularProgressIndicator();
        });
  }

  _showUrl(context, AsyncSnapshot<WebViewController> controller) async {
    String? url;
    if (controller.hasData) {
      url = await controller.data!.getTitle();
    }
    FlushbarMessage(context)
        .SuccessMessage('Info page en cours d\'implementation');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          controller.hasData ? '$url' : 'Unable to favorite',
        ),
      ),
    );
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> controller) {
          return FloatingActionButton(
            onPressed: () async {
              String? url;
              if (controller.hasData) {
                url = await controller.data!.currentUrl();
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    controller.hasData
                        ? 'Favorited $url'
                        : 'Unable to favorite',
                  ),
                ),
              );
            },
            child: const Icon(Icons.favorite),
          );
        });
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

_errorUrl(context, controller, String url) {
  Alert(
      context: context,
      title: "Connexion non disponible",
      //type: AlertType.warning,
      desc: "Veuillez reessayer",
      onWillPopActive: true,
      closeIcon: const Icon(
        Icons.sync,
        color: Colors.white,
      ),
      closeFunction: () {
        _reloadPage(controller);
        Navigator.pop(context);
      },
      image: const GFImageOverlay(
        height: 300,
        width: 300,
        shape: BoxShape.circle,
        image: AssetImage("assets/images/sn.png"),
        boxFit: BoxFit.cover,
      ),
      content: Column(
        children: const <Widget>[],
      ),
      buttons: [
        DialogButton(
          child: const Text(
            "Reessayer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            _reloadPage(controller);
            Navigator.pop(context);
          },
          color: Constants.PRIMARY_COLOR,
        ),
      ]).show();
}

_onProgressUrl(context, progress) {
  return const Center(child: GFLoader(type: GFLoaderType.ios));
}

Future<void> _loadUrlPaymentRequest(
    WebViewController controller, BuildContext context, String url) async {
  final WebViewRequest request = WebViewRequest(
    uri: Uri.parse(url),
    method: WebViewRequestMethod.get,
  );
  await controller.loadRequest(request);
}

_loadUrlPayment(
    Future<WebViewController> _webViewControllerFuture, String url) {
  _webViewControllerFuture
      .then((controller) async => {await controller.loadUrl(url)});
}

_reloadPage(Future<WebViewController> _webViewControllerFuture) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  String? url = localStorage.getString(Constants.YOWPAY_URL_DEFAULT);
  if (url != null) {
    _webViewControllerFuture.then((controller) async => {
          //await controller.reload(),
          await controller.loadUrl(url)
        });
  }
}

_goBackPage(Future<WebViewController> _webViewControllerFuture) {
  _webViewControllerFuture.then((controller) async => {
        await controller.reload() //.goBack(),
      });
}

_goForwardPage(Future<WebViewController> _webViewControllerFuture) {
  _webViewControllerFuture.then((controller) async => {
        //await controller.goForward(),
      });
}

Future<void> onDeconnexionRequest(
    WebViewController controller, BuildContext context, String url) async {
  url = url + "web/session/logout?redirect=/";
  final WebViewRequest request = WebViewRequest(
    uri: Uri.parse(url),
    method: WebViewRequestMethod.get,
    //headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
    //body: Uint8List.fromList('Test Body'.codeUnits),
  );
  await controller.loadRequest(request);
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  navigationDelegate,
  doPostRequest,
  setCookie,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller, CookieManager? cookieManager, {Key? key})
      : cookieManager = cookieManager ?? CookieManager(),
        super(key: key);

  final Future<WebViewController> controller;
  late final CookieManager cookieManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          key: const ValueKey<String>('ShowPopupMenu'),
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data!, context);
                break;
              case MenuOptions.listCookies:
                _onListCookies(controller.data!, context);
                break;
              case MenuOptions.clearCookies:
                onClearCookies(context);
                break;
              case MenuOptions.doPostRequest:
                _onDoPostRequest(controller.data!, context);
                break;
              case MenuOptions.setCookie:
                _onSetCookie(controller.data!, context);
                break;
              case MenuOptions.navigationDelegate:
              // TODO: Handle this case.
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              enabled: controller.hasData,
              child: const Text('Show user agent'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.doPostRequest,
              child: Text('Post Request'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.setCookie,
              child: Text('Set cookie'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    await controller.runJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }

  Future<void> _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.runJavascriptReturningResult('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  Future<void> onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> _onSetCookie(
      WebViewController controller, BuildContext context) async {
    await cookieManager.setCookie(
      const WebViewCookie(
          name: 'foo',
          value: 'bar',
          domain: 'https://yowitweb-ypay-ypay-test-6591479.dev.odoo.com',
          path: '/my'),
    );
    await controller
        .loadUrl('https://yowitweb-ypay-ypay-test-6591479.dev.odoo.com/my');
  }

  Future<void> _onDoPostRequest(
      WebViewController controller, BuildContext context) async {
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse(
          'https://yowitweb-ypay-ypay-test-6591479.dev.odoo.com/my/post'),
      method: WebViewRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(request);
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture, {Key? key})
      : assert(_webViewControllerFuture != null),
        super(key: key);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoBack()) {
                        await controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No back history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller!.canGoForward()) {
                        await controller.goForward();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No forward history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller!.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
