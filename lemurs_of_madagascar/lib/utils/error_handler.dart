import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';

class LOMException implements Exception {

  int statusCode;

  LOMException(this.statusCode):super();
}

class ErrorHandler{

  static handle(BuildContext context,int code){
    switch(code){
      case 401:{
        showAlert(
          context: context,
          title: ErrorText.credentialTitleError,
          body: ErrorText.credentialMessageError,
          actions: [],
        );
        break;
      }
    }
  }



}