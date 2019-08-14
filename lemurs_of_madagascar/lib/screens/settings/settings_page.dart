import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xlive_switch/xlive_switch.dart';


abstract class SettingsPageContract {
  void onSyncSuccess();
  void onSyncFailure(int statusCode);
  void onSocketFailure();
}

class SettingsPagePresenter {
  SettingsPageContract _settingsView;
  RestData rest = RestData();
  SettingsPagePresenter(this._settingsView);

  sync(String settingsName, String settingsValue) {
    rest.syncSettings(settingsName, settingsValue)
        .then((success) {
          if(success){
            print("ATO1");
            _settingsView.onSyncSuccess();
          }else {
            print("ATO2");
          }
        })
        .catchError((error) {

          if(error is SocketException) _settingsView.onSocketFailure();
          if(error is LOMException) {
            _settingsView.onSyncFailure(error.statusCode);
          }
        });
  }
}

class SettingsPage extends StatefulWidget {

  final String title;

  SettingsPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState(this.title);
  }

}

class SettingsPageState extends State<SettingsPage> implements SettingsPageContract  {

  String title;
  bool _value = false;
  bool _isLoading = false;
  SettingsPagePresenter presenter;
  static const _KEY_PUBLIC_SETTINGS = "public_list";


  SettingsPageState(this.title){
    presenter = SettingsPagePresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _loadPublicListSettings();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
          ],
          title: _buildTitle(),
        ),
        //body: SafeArea(child:_buildBody(context)),
        body: ModalProgressHUD(
            child: SafeArea(child:_buildBody(context)),
            opacity: 0.5,
            //color: Constants.mainSplashColor,
            progressIndicator: CircularProgressIndicator(),
            //offset: 5.0,
            //dismissible: false,
            inAsyncCall: _isLoading),
      );
  }

  Widget _buildTitle() {
    String title  = this.title;
    return Text(title);
  }


  Widget _buildBody(BuildContext buildContext){
    return Container(
      child: _buildSettingsListView(buildContext),
    );
  }

  Widget _buildSettingsListView(BuildContext buildContext) {

      return ListView(
        children:[
          ListTile(
            title: Column(children: <Widget>[
              Padding(padding: EdgeInsets.only(top:10),),
              Text("Make my sightings and lemur life list public", style: Constants.defaultTextStyle),
              Text("Other users can see your list on www.lemursofmadagascar.com", style: Constants.defaultSubTextStyle.copyWith(color: Colors.blueGrey)),

            ],),
            leading: XlivSwitch(
              value: _value,
              onChanged: (bool value) {
                //Navigator.pop(context); // Close the drawer
                _changeValueStatus(buildContext);
              },),
            onTap: () {
              //Navigator.pop(context); // Close the drawer
              _changeValueStatus(buildContext);
            },
          ),
          Divider(height: 20,color: Colors.blueGrey,),
        ]
      );

  }

  _loadPublicListSettings() async {

    String publicListSettings = await LOMSharedPreferences.loadString(_KEY_PUBLIC_SETTINGS);
    _value = false;
    if(publicListSettings == "1" && publicListSettings != null ){
      setState(() {
        _value = true;
      });
    }

  }

  _changeValueStatus(BuildContext buildContext){

    String value = "0";

    setState(() {
      _value = !_value;
      _isLoading = true;
    });

    value = _value ? "1" : "0";

    presenter.sync(_KEY_PUBLIC_SETTINGS,value);


  }

  @override
  void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }

  @override
  void onSyncFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handle(context, statusCode);
  }

  @override
  void onSyncSuccess() {


   String value = _value ? "1" : "0";

    LOMSharedPreferences.setString(_KEY_PUBLIC_SETTINGS,value).then((_){
      print("SUCCESS SETTINGS CHANGE to $value");
    });

    setState(() {
      _isLoading = false;
    });

  }



}

