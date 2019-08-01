import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/lom_map.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class SiteDetailsPage extends StatefulWidget {

  final String title;
  final Site site;

  SiteDetailsPage(this.title,this.site);

  @override
  State<StatefulWidget> createState() {
    return SiteDetailsPageState(this.title,this.site);
  }

}

class SiteDetailsPageState extends State<SiteDetailsPage>   {

  String title;
  Site site;

  SiteDetailsPageState(this.title,this.site);

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
                _buildSiteDetailsView(buildContext),
              ],
            )),
      )
    ]);
  }


  Widget _buildSiteDetailsView(BuildContext buildContext) {

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Site.loadHeroTitle(this.site,style: Constants.defaultTextStyle.copyWith(fontSize: 25,fontWeight: FontWeight.w500)),
          Site.buildTextInfo(this.site),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _getMap(),
          ),
        ]);
  }


  Widget _getMap() {

    if(this.site != null) {

      //print("NID ${this.site.mapID}");
      LOMMap map = LOMMap();
      map.nid = site.mapID;


      return FutureBuilder<String>(
        future: map.getLOMMapFileName(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            map.fileName = snapshot.data;
            return Container(
                child: map.getMapWidget(),
            );
          }
          return Center(child:CircularProgressIndicator());
        }
      );

    }

    return Container();

  }


}

