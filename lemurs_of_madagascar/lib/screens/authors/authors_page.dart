import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/author_database_helper.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class AuthorsPage extends StatefulWidget {

  final String title;

  AuthorsPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return AuthorsPageState(this.title);
  }

}

class AuthorsPageState extends State<AuthorsPage>   {

  String title;

  AuthorsPageState(this.title);

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
      child: _buildAuthorsListView(buildContext),
    );
  }

  Widget _buildAuthorsListView(BuildContext buildContext) {

    return FutureBuilder<List<Author>> (
      future:_loadData(),
      builder: (context,authorSnapshot){

        if(authorSnapshot.hasData){

          return ListView.builder(
              itemCount: authorSnapshot.data.length,
              itemBuilder: (context,index){
                Author author = authorSnapshot.data[index];
                return buildCellItem(buildContext, author,index);
              }
          );

        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }

  Future<List<Author>> _loadData() async {

    AuthorDatabaseHelper db = AuthorDatabaseHelper();
    return await db.getAuthorList();

  }

  Widget buildCellItem(BuildContext context, Author author,int index,
      {
      double elevation     = 2.5,
      double borderRadius  = Constants.speciesImageBorderRadius,
      double imageWidth    = Constants.listViewImageWidth,
      double imageHeight   = Constants.listViewImageHeight,
      AuthorImageClipperType imageClipper = AuthorImageClipperType.rectangular}) {

    if (author != null) {

      return Container(

        child:

        GestureDetector(
            onTap: () {
              //SpeciesListPageState.navigateToSpeciesDetails(context, species);
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
                        Author.buildAuthorPhoto(author,width: imageWidth,height: imageHeight,imageClipper: imageClipper),
                        Container(width: 10),
                        Author.buildAuthorName(author),
                      ])),
                )))),

        /*ListTile(
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
                        Author.buildCellInfo(author,context,index),
                      ),
                    )))),*/
      );
    }

    return Container();
  }

}

