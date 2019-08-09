import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';



abstract class LoginPageContract {
  void onLoginSuccess(List<dynamic> userAndSession, {String destPageName = "/introduction"});
  void onLoginFailure(int statusCode);
  void onSocketFailure();
}

class LoginPagePresenter {
  LoginPageContract _loginView;
  RestData loginRestAPI = RestData();
  LoginPagePresenter(this._loginView);

  doLogin(String userName, String passWord) {
    loginRestAPI
        .login(userName, passWord)
        .then((listOfUserAndSession) => _loginView.onLoginSuccess(listOfUserAndSession))
        .catchError((error) {

          if(error is SocketException) _loginView.onSocketFailure();
          if(error is LOMException) {
            _loginView.onLoginFailure(error.statusCode);
          }
    });
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {

  EdgeInsets edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  EdgeInsets edgePadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName;
  String _passWord;

  LoginPagePresenter _loginPresenter;

  _LoginPageState() {
    _loginPresenter = LoginPagePresenter(this);
    _userName = "";
    _passWord = "";
  }

  ThemeData _buildTheme(){
    final ThemeData base = ThemeData();
    return base.copyWith(
      hintColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {

    final loginBtn = Padding(
      padding: edgeInsets,
        child:  _isLoading ? CircularProgressIndicator() : Material(
      elevation: 5.0,

      borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
      color: Constants.mainColor,
      child:  MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: edgePadding,
        onPressed: _submit,
        child:  Text("Login",
            textAlign: TextAlign.center,
            style: Constants.buttonTextStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ));

    final registerBtn = Padding(
        padding: edgeInsets,
        child: _isLoading ? Container() : OutlineButton(
        child:  Text("Register",
            textAlign: TextAlign.center,
            style: Constants.subButtonTextStyle
                .copyWith(color: Constants.mainColor, fontWeight: FontWeight.bold)),
        onPressed: () {
          //Navigator.pushNamed(context, "/register");
          Navigator.of(context).pushReplacementNamed("/register");

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
      children: <Widget>[
        Container(
          height: 50.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.85,
          child:ConstantImage.getTextLogo(),

            /*Text(
          "Lemurs of madagascar",
          style: Constants.appTitle.copyWith(color: Constants.mainColor,fontWeight: FontWeight.w500),
          textScaleFactor: 2,
          textAlign: TextAlign.center
          )*/
        ),
        Container(
          height: 20.0,
        ),
        Container(child: Form(
          key: formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                  obscureText: true,
                  onSaved: (val) => _passWord = val,
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
              )
            ],
          ),
        )
        ),
        loginBtn,
        Container(
          height: 10.0,
        ),
        registerBtn,
      ],
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      /*appBar: new AppBar(
        title: new Text("Login Page"),
      ),*/
      key: scaffoldKey,

      body: SafeArea(
        child: ListView(

          children:<Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [new Center(
              child: loginForm,
            ),],
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,

          )
        ]),
      ), //-----
    );
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _loginPresenter.doLogin(_userName, _passWord);
      });
    }
  }

  /*
  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }*/


  @override
  void onLoginSuccess(List<dynamic> listOfUserAndSession, {String destPageName = "/introduction"}) async {
    setState(() {
      _isLoading = false;
    });

    //print("[LOGIN_PAGE::onLoginSuccess()]" + listOfUserAndSession.toString());

    User user = listOfUserAndSession[0];
    UserSession userSession = listOfUserAndSession[1];

    user.saveToSharedPreferences();
    UserSession.startSession(userSession);

    Navigator.of(context).pushReplacementNamed(destPageName);
  }

  @override
  void onLoginFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handle(context, statusCode);
  }

  @override
  void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }
}
