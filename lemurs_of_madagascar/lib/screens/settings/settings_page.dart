import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xlive_switch/xlive_switch.dart';


class SettingsPage extends StatefulWidget {

  final String title;

  SettingsPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState(this.title);
  }

}

class SettingsPageState extends State<SettingsPage>   {

  String title;
  bool _value = false;
  bool _isLoading = false;

  SettingsPageState(this.title);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Constants.backGroundColor,
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
            title: Text("Make my sightings and lemur life list public on www.lemursofmadagascar.com", style: Constants.defaultTextStyle),
            leading: XlivSwitch(
              value: _value,
              onChanged: (bool value) {
                Navigator.pop(context); // Close the drawer
                _changeValueStatus(buildContext);
              },),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              _changeValueStatus(buildContext);
            },
          ),
        ]
      );

  }

  _changeValueStatus(BuildContext buildContext){

    setState(() {
      _value = !_value;
      _isLoading = true;
    });


  }



}

