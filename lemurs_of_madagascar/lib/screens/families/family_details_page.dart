import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/family.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class FamilyDetailsPage extends StatefulWidget {

  final String title;
  final Family family;

  FamilyDetailsPage(this.title,this.family);

  @override
  State<StatefulWidget> createState() {
    return FamilyDetailsPageState(this.title,this.family);
  }

}

class FamilyDetailsPageState extends State<FamilyDetailsPage>   {

  String title;
  Family family;

  FamilyDetailsPageState(this.title,this.family);

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
                _buildFamilyDetailsView(buildContext),
              ],
            )),
      )
    ]);
  }


  Widget _buildFamilyDetailsView(BuildContext buildContext) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: Family.buildFamilyPhoto(this.family,width: MediaQuery.of(context).size.width ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
              child: Center(child: Family.loadName(this.family,style: Constants.defaultTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w600))),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Family.loadFamilyDetails(this.family,truncateLen: this.family.description.length),
            ),
          ]),
    );
  }



}

