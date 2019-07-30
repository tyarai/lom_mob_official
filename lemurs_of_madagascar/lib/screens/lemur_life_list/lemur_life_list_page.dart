import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/database/comment_database_helper.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_edit_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LemurLifeListPage extends StatefulWidget {

  final String title;

  LemurLifeListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _LemurLifeListPageState(this.title);
  }

}

class _LemurLifeListPageState extends State<LemurLifeListPage>   {

  String title;

  _LemurLifeListPageState(this.title);

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
          actions: <Widget>[],
          title: _buildTitle(),
        ),
        body: _buildBody(),
      );
  }

  Widget _buildTitle() {
    return Text(this.title);
  }

  Widget _buildBody(){
    return Container(

    );
  }


}

