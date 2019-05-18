import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/validator.dart';
import 'package:lemurs_of_madagascar/screens/user/login_page.dart';


abstract class RegisterPageContract {
  void onRegisterSuccess(User user, {String destPageName = "/introduction"});
  void onRegisterFailure(int statusCode);
  void onSocketFailure();
}

class RegisterPagePresenter {


  RegisterPageContract _registerView;
  RestData registerRestAPI = RestData();
  RegisterPagePresenter(this._registerView);

  doRegister(String userName, String passWord, String email) {
    registerRestAPI
        .register(userName, passWord,email)
        .then((User user) =>  _registerView.onRegisterSuccess(user))
        .catchError(( error) {

          if (error is SocketException) _registerView.onSocketFailure();
          if (error is LOMException) {
            _registerView.onRegisterFailure(error.statusCode);
          }

        });
  }
}

class RegisterPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }

}

class _RegisterPageState extends State<RegisterPage> implements RegisterPageContract,LoginPageContract  {

  EdgeInsets edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  EdgeInsets edgePadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName;
  String _passWord1;
  String _passWord2;
  String _mail;

  RegisterPagePresenter _registerPresenter;
  LoginPagePresenter _loginPresenter;



  _RegisterPageState() {
    _registerPresenter = RegisterPagePresenter(this);
    _loginPresenter    = LoginPagePresenter(this);
    _userName  = "";
    _passWord1 = "";
    _passWord2 = "";
    _mail      = "";
  }

  @override
  Widget build(BuildContext context) {

    final registerBtn = Padding(
        padding: edgeInsets,
        child:  _isLoading ? CircularProgressIndicator() : Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
          color: Constants.mainColor,
          child:  MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: edgePadding,
            onPressed: _submit,
            child:  Text("Register",
                textAlign: TextAlign.center,
                style: Constants.buttonTextStyle
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ));


    final alreadyHaveAnAccountBtn = Padding(
      padding: edgeInsets,
      child: _isLoading ? Container() : OutlineButton(

        child:  Text("Already have an account",
            textAlign: TextAlign.center,
            style: Constants.subButtonTextStyle
                .copyWith(color: Constants.mainColor, fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/login");
          //Navigator.pushNamed(context, "/login");
          //Navigator.pop(context);
        }, //callback when button is clicked
        borderSide: BorderSide(
          color: Constants.registerBtnBorderColor, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 0.5, //width of the border
        ),
      )
    );


    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[

        Container(
          height: 20.0,
        ),
        Container(child: Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  onSaved: (val) => _userName = val,
                  validator: (String arg) {
                    if(arg.length < Constants.minUsernameLength) {
                      return ErrorText.loginNameError;
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Username",
                      icon: new Icon(
                        Icons.person,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  onSaved: (val) => _mail = val,
                  validator: (String arg) {
                    if(! Validator.validateEmail(arg)) {
                      return ErrorText.emailError;
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Mail",
                      icon: new Icon(
                        Icons.mail,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _passWord1 = val,
                  validator: (String arg) {
                    if(arg.length == 0) {
                      return ErrorText.passwordError;
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      icon: new Icon(
                        Icons.lock,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _passWord2 = val,
                  validator: (String arg) {
                    if(arg.length == 0) {
                      return ErrorText.passwordError;
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Password confirmation",
                      icon: new Icon(
                        Icons.lock,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Password confirmation",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              )
            ],
          ),
        )
        ),

        registerBtn,
        alreadyHaveAnAccountBtn,

      ],
    );

    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text("Login Page"),
      ),*/
      key: scaffoldKey,
      body: ListView(

          children:<Widget>[
            Container(
              child: new Center(
                child: loginForm,
              ),
            )
          ]), //-----
    );
  }

  void _submit() {

    final form = formKey.currentState;

    if (form.validate()) {

      setState(() {
        _isLoading = true;
        form.save();

        if (_passWord1 != _passWord2){
          showAlert(
            context: context,
            title: ErrorText.credentialTitle,
            body: ErrorText.registerPasswordsDoNotMatch,
            actions: [],
          );
          _isLoading = false;

        }else {
          _registerPresenter.doRegister(_userName, _passWord1, _mail);
        }
      });
    }
  }

  @override
  void onRegisterFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handle(context, statusCode);
  }

  @override
  void onRegisterSuccess(User newUser, {String destPageName = "/introduction"}) {
    if(newUser != null) {
      print("> logining in new registered user :"+ newUser.name);
      this._loginPresenter.doLogin(newUser.name, newUser.password);
    }
  }

  @override
  void onLoginFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handle(context, statusCode);
  }


  @override
  void onLoginSuccess(List<dynamic> listOfUserAndSession, {String destPageName = "/introduction"}) async {
    setState(() {
      _isLoading = false;
    });

    User user = listOfUserAndSession[0];
    UserSession userSession = listOfUserAndSession[1];

    user.saveToSharedPreferences();
    UserSession.startSession(userSession);

    Navigator.of(context).pushReplacementNamed(destPageName);
  }

  /*
  @override
  void onLoginSuccess(User user, {String destPageName = "/introduction"}) {
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(destPageName);
  }*/

  @override
  void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }


}

