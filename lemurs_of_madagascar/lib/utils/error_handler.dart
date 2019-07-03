import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';

class LOMException implements Exception {

  int statusCode;

  LOMException(this.statusCode):super();
}

class ErrorHandler{

  static handleSocketError(BuildContext context){
    showAlert(
      context: context,
      title: ErrorText.serverTitle,
      body: ErrorText.unreachableAddress,
      actions: [],
    );
  }

  static handleException(BuildContext context,Exception e){
    showAlert(
      context: context,
      title: ErrorText.serverTitle,
      body: e.toString(),
      actions: [],
    );
  }




  static handle(BuildContext context,int code){
    switch(code){
      case 401:{
        showAlert(
          context: context,
          title: ErrorText.serverTitle,
          body: ErrorText.unauthorizedOperation,
          actions: [],
        );
        break;
      }
      case 403:{
        showAlert(
          context: context,
          title: ErrorText.serverTitle,
          body: ErrorText.anonymousUser,
          actions: [],
        );
        break;
      }
      case 406:{
        showAlert(
          context: context,
          title: ErrorText.serverTitle,
          body: ErrorText.unauthorizedOperation,//ErrorText.takenNameOrMail,
          actions: [],
        );
        break;
      }
    }
  }



}