import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FlushbarMessage {
  const FlushbarMessage(this.context);
  final BuildContext context;

  ErrorMessage(error) {
    Flushbar(
      title: 'ERREUR',
      message: error,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 5),
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        Icons.error_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      //leftBarIndicatorColor: Colors.blue[300],
    ).show(context);
  }
  
  InfoMessage(info) {
      Flushbar(
        title: 'INFO',
        message: info,
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.blueAccent,
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        icon: Icon(
          Icons.info_outline_rounded,
          size: 28.0,
          color: Colors.orange,
        ),
        //leftBarIndicatorColor: Colors.blue[300],
      ).show(context);

    }

  SuccessMessage(success) {
    Flushbar(
      title: 'SUCCES',
      message: success,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 5),
      backgroundColor: Colors.lightGreen,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      //leftBarIndicatorColor: Colors.blue[300],
    ).show(context);

  }

  StaticMessage(message) {
    Future.delayed(const Duration(seconds: 1)).then((value) =>
    Flushbar(
      title: 'INFO',
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      duration: Duration(seconds: 5),
      backgroundColor: Constants.PRIMARY_COLOR,
      showProgressIndicator: true,
      //margin: EdgeInsets.all(8),
      //borderRadius: BorderRadius.circular(8),
      icon: Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      //leftBarIndicatorColor: Colors.blue[300],
    ).show(context)
    );

  }

  EnConstructionMessage(enContruction) {
    Flushbar(
      title: 'EN CONSTRUCTION',
      message: enContruction,
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Constants.PRIMARY_COLOR,
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        Icons.check_circle_outline,
        size: 28.0,
        color: Colors.white,
      ),
      //leftBarIndicatorColor: Colors.blue[300],
    ).show(context);

  }

  ConnexionStatus(String message, bool status) {
    Flushbar(
      title: 'Connection',
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: status ? Colors.green : Colors.red,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(
        status ?Icons.check_circle_outline : Icons.error_outline,
        size: 28.0,
        color: Colors.white,
      ),
    ).show(context);
  }
}
  
  
