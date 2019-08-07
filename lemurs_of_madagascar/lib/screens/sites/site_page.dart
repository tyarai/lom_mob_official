import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/screens/sites/site_details_page.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';


class SitePage extends StatefulWidget {

  final String title;

  SitePage({this.title});

  @override
  State<StatefulWidget> createState() {
    return SitePageState(this.title);
  }

}

class SitePageState extends State<SitePage>   {

  String title;
  List<Site> _siteList = List();

  SitePageState(this.title);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _initSiteList();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Constants.backGroundColor,
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            _buildSearch(),
          ],
          title: _buildTitle(),
        ),
        body: _buildBody(context),
      );
  }

  Widget _buildTitle() {
    String title  = this.title;
    return Text(title);

  }

  Widget _buildSearch(){
    return IconButton(
      icon: Icon(Icons.search),
      onPressed:(){
        showSearch(
            context: context,
            delegate: DataSearch(siteList: this._siteList));
      },
    );
  }

  _initSiteList() async {
    if (_siteList.length == 0) {
      _siteList = await _loadSiteFromDatabase();
    }
  }

  Future<List<Site>> _loadSiteFromDatabase({int pageIndex,int limit}) async {
    SiteDatabaseHelper siteDBHelper = SiteDatabaseHelper();
    return siteDBHelper.getSiteList().then((futureList){
      return futureList;
    });

  }

  Widget _buildBody(BuildContext buildContext){
    return Container(
      child: _buildSiteListView(buildContext),
    );
  }

  Widget _buildSiteListView(BuildContext buildContext) {

    return FutureBuilder<List<Site>> (
      future:_loadData(),
      builder: (context,siteSnapshot){

        if(siteSnapshot.hasData){

          return ListView.builder(
            itemCount: siteSnapshot.data.length,
            itemBuilder: (context,index){

              Site site = siteSnapshot.data[index];
              return SitePageState.buildCellItem(buildContext, site,index);
            }
          );
        }

        return Center(child:CircularProgressIndicator());
      },
    );
  }

  Future<List<Site>> _loadData() async {

    SiteDatabaseHelper db = SiteDatabaseHelper();
    return await db.getSiteList();

  }

  static Widget buildCellItem(BuildContext context, Site  site,int index,
      {
        double elevation     = 2.5,
        double borderRadius  = Constants.siteImageBorderRadius,
        double imageWidth    = Constants.listViewImageWidth,
        double imageHeight   = Constants.listViewImageHeight,
        AuthorImageClipperType imageClipper = AuthorImageClipperType.rectangular}) {

    if (site != null) {

      return Container(

        child:

        GestureDetector(
            onTap: () {
              //SpeciesListPageState.navigateToSpeciesDetails(context, site);
              SitePageState.navigateToSiteDetails(context,site);
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(Constants.siteImageBorderRadius),
                      shadowColor: Colors.blueGrey,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //Family.buildFamilyPhoto(family,width: imageWidth,height: imageHeight,imageClipper: imageClipper),
                            Expanded(flex:2,child: _buildIndexText(index,align: TextAlign.center)),
                            Container(width: 5),
                            Expanded(flex:8,child: Site.loadHeroTitle(site)),
                          ]),
                    )))),
      );
    }

    return Container();
  }

  static Widget _buildIndexText(int index,{TextAlign align = TextAlign.start}){
    if(index != null){
      return Padding(
        padding: EdgeInsets.only(left:15,top:10,bottom: 10,right: 15),
        child: Text((index + 1).toString(),style:Constants.defaultTextStyle.copyWith(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.w300,),textAlign: align,),
      );
    }
    return Container();
  }

  static void navigateToSiteDetails(BuildContext context,Site site){

    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: SiteDetailsPage(
                        "Watching sites",
                        site
                    ),
                  );
                });
          },
          transitionDuration: Duration(milliseconds: Constants.siteHeroTransitionDuration)),
    );

  }

}

class DataSearch extends SearchDelegate<List<Site>> {

  List<Site> siteList        = List();
  List<Site> recentSite      = List();
  List<Site> suggestionsList = List();

  initData() async{
    recentSite = await LOMSharedPreferences.loadRecentSiteSearch();
  }

  DataSearch({this.siteList}){
    initData();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear),
        onPressed: (){
          query = "" ; // Clear the search query
        },),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation),
      onPressed:(){
        close(context, null);
      } ,);
  }

  @override
  Widget buildResults(BuildContext context) {
    if(query.isNotEmpty) {
      return _buildSearchResult();
    }
    return Container();

  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    suggestionsList = query.isEmpty ? recentSite :

    siteList.where((site) =>
      site.title.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(

      itemCount: suggestionsList.length,
      itemBuilder: (BuildContext context, int index) => SitePageState.buildCellItem(context,suggestionsList[index],index),

    );
  }

  Widget _buildSearchResult(){
    return ListView.builder(
        itemCount: this.suggestionsList.length,
        itemBuilder: (BuildContext context,int index){
          return SitePageState.buildCellItem(context,this.suggestionsList[index],index);
        });
  }




}

