import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class AuthorDetailsPage extends StatefulWidget {

  final String title;
  final Author author;

  AuthorDetailsPage(this.title,this.author);

  @override
  State<StatefulWidget> createState() {
    return AuthorDetailsPageState(this.title,this.author);
  }

}

class AuthorDetailsPageState extends State<AuthorDetailsPage>   {

  String title;
  Author author;

  AuthorDetailsPageState(this.title,this.author);

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

        backgroundColor: Constants.mainColor,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          actions: <Widget>[],
          title: _buildTitle(),
        ),
        body: _buildBody(context),
      );
  }

  Widget _buildTitle() {
    return Text(this.title);

  }

  Widget _buildBody(BuildContext buildContext){

    return ListView(children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Material(
            elevation: 5.0,
            borderRadius:
            BorderRadius.circular(Constants.speciesImageBorderRadius),
            shadowColor: Colors.blueGrey,
            child: Column(
              children: <Widget>[
                Container(height: 20),
                _buildAuthorDetailsView(buildContext),
              ],
            )),
      )
    ]);
  }


  Widget _buildAuthorDetailsView(BuildContext buildContext) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Center(child:Author.buildAuthorPhoto(this.author,width: 200,height: 200)),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: Center(child: Author.loadName(this.author,style: Constants.defaultTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w600))),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Author.loadAuthorDetails(this.author,truncateLen: this.author.details.length),
            ),

            /*Container(height: 10),
            Row(children: <Widget>[
              Species.buildTextInfo(species,
                  crossAlignment: CrossAxisAlignment.center),
            ]),
            Container(height: 30),
            Row(children: <Widget>[
              widget,
            ]),
            Container(height: 20),
            secondaryWidget != null
                ? Column(children: <Widget>[
              secondaryWidget,
            ])
                : Container(),*/
          ]),
    );
  }


  Widget _showTab() {

  }



}

