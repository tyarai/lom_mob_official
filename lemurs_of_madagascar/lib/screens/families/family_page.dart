import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/author_database_helper.dart';
import 'package:lemurs_of_madagascar/database/family_database_helper.dart';
import 'package:lemurs_of_madagascar/models/family.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/screens/families/family_details_page.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class FamilyPage extends StatefulWidget {

  final String title;

  FamilyPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return FamilyPageState(this.title);
  }

}

class FamilyPageState extends State<FamilyPage>   {

  String title;

  FamilyPageState(this.title);

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
    String title  = this.title;
    return Text(title);

  }

  Widget _buildBody(BuildContext buildContext){
    return Container(
      child: _buildFamilyListView(buildContext),
    );
  }

  Widget _buildFamilyListView(BuildContext buildContext) {

    return FutureBuilder<List<Family>> (
      future:_loadData(),
      builder: (context,authorSnapshot){

        if(authorSnapshot.hasData){

          return ListView.builder(
              itemCount: authorSnapshot.data.length,
              itemBuilder: (context,index){
                Family family = authorSnapshot.data[index];
                return buildCellItem(buildContext, family,index);
              }
          );

        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }

  Future<List<Family>> _loadData() async {

    FamilyDatabaseHelper db = FamilyDatabaseHelper();
    return await db.getFamilyList();

  }

  Widget buildCellItem(BuildContext context, Family  family,int index,
      {
        double elevation     = 2.5,
        double borderRadius  = Constants.speciesImageBorderRadius,
        double imageWidth    = Constants.listViewImageWidth,
        double imageHeight   = Constants.listViewImageHeight,
        AuthorImageClipperType imageClipper = AuthorImageClipperType.rectangular}) {

    if (family != null) {

      return Container(

        child:

        GestureDetector(
            onTap: () {
              //SpeciesListPageState.navigateToSpeciesDetails(context, species);
              FamilyPageState.navigateToFamilyDetails(context,family);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
                      shadowColor: Colors.blueGrey,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //Family.buildFamilyPhoto(family,width: imageWidth,height: imageHeight,imageClipper: imageClipper),
                                _buildIndexText(index),
                                Container(width: 10),
                                Family.buildFamilyName(family),
                              ])),
                    )))),
      );
    }

    return Container();
  }

  static Widget _buildIndexText(int index){
    if(index != null){
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text((index + 1).toString(),style:Constants.defaultTextStyle.copyWith(fontSize: 40,color: Colors.blue,fontWeight: FontWeight.w300),),
      );
    }
    return Container();
  }

  static void navigateToFamilyDetails(BuildContext context,Family family){

    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: FamilyDetailsPage(
                        "Family",
                        family
                    ),
                  );
                });
          },
          transitionDuration: Duration(milliseconds: Constants.speciesHeroTransitionDuration)),
    );

  }



}

