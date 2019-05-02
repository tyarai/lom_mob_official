import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';

abstract class LoginPageContract {
  void onLoginSuccess(User user,{String destPageName = "/introduction"});
  void onLoginFailure(String error);
}

class LoginPagePresenter {
  LoginPageContract _view;
  RestData api = RestData();
  LoginPagePresenter(this._view);

  doLogin(String userName, String passWord) {
    api
        .login(userName, passWord)
        .then((user) => _view.onLoginSuccess(user))
        .catchError((onError) => _view.onLoginFailure(onError.toString()));
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
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

    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("Login"),
      color: Colors.green,
    );

    var loginForm = new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(
          "Lemurs of madagascar",
          textScaleFactor: 2.0,
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _userName = val,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _passWord = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              )
            ],
          ),
        ),
        loginBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
      ),
      key: scaffoldKey,
      body: ListView(children: <Widget>[
        Container(
          child: new Center(
            child: loginForm,
          ),
        )
      ]),
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
  void onLoginSuccess(User user,{String destPageName = "/introduction"}) async {
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });
    //var db = new DatabaseHelper();
    //await db.saveUser(user);
    Navigator.of(context).pushNamed(destPageName);
  }

  @override
  void onLoginFailure(String error) {
    //@TODO : Implement something on login failure
    print("LOGIN ERROR: "+error);
  }
}
