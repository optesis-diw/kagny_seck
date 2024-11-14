import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class DialogBuilder {

  const DialogBuilder(this.context);
  final BuildContext context;

  /// loading dialog
  Future<void> showIosLoading() => showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) => WillPopScope(
      onWillPop: () async => true,
      child: const GFLoader(
        type: GFLoaderType.ios,
      )
    ),
  );

  /// result dialog
  Future<void> showResultDialog(String text) => showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: SizedBox(
          height: 100,
          width: 100,
          child: Column( children: <Widget> [
            Center(child: Text(text, textAlign: TextAlign.center)),
            IconButton(onPressed: () { Navigator.pop(context); },
                icon: const Icon(Icons.check, color: Colors.green,)
            )
          ])
      ),

    ),
  );
  Errormessage(error) {
    Flushbar(
      title: 'ERROR',
      message: error,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.orange,
    )
      .show(context);
  }
  hideDialog() {
    return Future.delayed(const Duration(seconds: 4));
  }
}