import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user, {String destPageName = "/introduction"});
  void onLoginFailure(int statusCode);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData restAPI = RestData();
  LoginPagePresenter(this._view);

  doLogin(String userName, String passWord) {
    restAPI
        .login(userName, passWord)
        .then((user) => _view.onLoginSuccess(user))
        .catchError((Object error) {
          //TODO Handle SocketException when the user does not have to internet. In that case SocketException is thrown instead of LOMException
          LOMException lomException = error as LOMException;
          //print("CODE: "+ lomException.statusCode.toString());
          _view.onLoginFailure(lomException.statusCode);
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

  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _userName;
  String _passWord;

  LoginPagePresenter _presenter;

  _LoginPageState() {
    _presenter = LoginPagePresenter(this);
    _userName = "";
    _passWord = "";
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    final loginBtn = Padding(
      padding: edgeInsets,
        child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
      color: Constants.mainColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: edgePadding,
        onPressed: _submit,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: Constants.buttonTextStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    ));

    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.85,
          child:
        Text(
          "Lemurs of madagascar",
          style: Constants.appTitle,
          textScaleFactor: 2.0,
          textAlign: TextAlign.center
          )
        ),
        Container(
          height: 20.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  onSaved: (val) => _userName = val,
                  validator: (String arg) {
                    if(arg.length < 4) {
                      return ErrorText.loginNameError;
                    }else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      //labelText: "Username",
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
                      //labelText: "Username",
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
        ),
        loginBtn
      ],
    );

    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text("Login Page"),
      ),*/
      key: scaffoldKey,
      body: SingleChildScrollView(child:
        Container(
          child: new Center(
            child: loginForm,
          ),
        )
      ),
    );
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doLogin(_userName, _passWord);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  void onLoginError(String error) {
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user,
      {String destPageName = "/introduction"}) async {
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });
    //var db = new DatabaseHelper();
    //await db.saveUser(user);
    Navigator.of(context).pushNamed(destPageName);
  }

  @override
  void onLoginFailure(int statusCode) {
    ErrorHandler.handle(context, statusCode);
  }
}
