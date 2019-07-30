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
import 'package:lemurs_of_madagascar/models/lemur_life_list.dart';
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
  int _lifeListCount = 0;

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
        body: _buildBody(context),
      );
  }

  Widget _buildTitle() {
    String countTitle  = _lifeListCount.toString() + " species in your lemur life list";
    return Text(countTitle);

  }

  Widget _buildBody(BuildContext buildContext){
    return Container(
      child: _buildLemurLifeListView(buildContext),
    );
  }

  /*Widget _buildSightingListView(BuildContext buildContext) {
    return PagewiseListView(
        pageSize: Constants.recordLimit,
        showRetry: false,
        itemBuilder: (context, entry, index) {
          LemurLifeList lifeList = entry;
          return this.buildCellItem(context, lifeList);
        },
        pageFuture: (pageIndex) {
          return _loadData(pageIndex:pageIndex * Constants.recordLimit);
        },
        errorBuilder: (context, error) {
          return Text('Error: $error');
        },
        loadingBuilder: (context) {
          return Center(child: CircularProgressIndicator());
        }
    );
  } */

  Widget _buildLemurLifeListView(BuildContext buildContext) {

    return FutureBuilder<List<LemurLifeList>> (
        future:_loadData(),
        builder: (context,lifeListSnapshot){

          if(lifeListSnapshot.hasData){

            return ListView.builder(
                itemCount: lifeListSnapshot.data.length,
                itemBuilder: (context,index){
                  LemurLifeList lifeList = lifeListSnapshot.data[index];
                  return buildCellItem(buildContext, lifeList,index);
                }
            );

          }
          return Center(child:CircularProgressIndicator());
        },
    );
  }


  Future<List<LemurLifeList>> _loadData({int pageIndex}) async {


    Future<User> user = User.getCurrentUser();

    return user.then((_user) {

      if (_user != null) {

        int currentUid = _user.uid;

        try {
          if (currentUid > 0) {

            SightingDatabaseHelper sightingDBHelper = SightingDatabaseHelper();

            return sightingDBHelper.getLemurLifeList(
                currentUid,
                pageIndex:pageIndex,
                limit:Constants.recordLimit
                ).then((_list) {
                  setState(() {
                    _lifeListCount = _list.length;
                  });
                  return _list;
            });
          }
        } catch (e) {
          print("[LemurLifeList::_loadData()] Error : " + e.toString());
        }
      }

      return List();
    });

  }

  Widget buildCellItem(BuildContext context, LemurLifeList lifeList,int index) {

    if (lifeList != null) {
      return Container(
        child: ListTile(
            contentPadding: EdgeInsets.only(left: 8.0, right: 8.0),
            onTap: () {
            },
            title: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                    child: Material(
                      elevation: 1.0,
                      borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
                      shadowColor: Colors.blueGrey,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child:
                        LemurLifeList.buildCellInfo(lifeList,context,index),
                      ),
                    )))),
      );
    }

    return Container();
  }

}

