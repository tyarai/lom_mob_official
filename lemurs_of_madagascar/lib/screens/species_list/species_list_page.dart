import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/screens/species_list/species_details_page.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';


class SpeciesListPage extends StatefulWidget {
  SpeciesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SpeciesListPageState();
  }
}



class SpeciesListPageState extends State<SpeciesListPage> {
  List<Species> _speciesList = List<Species>();

  SpeciesListPageState();

  @override
  void initState() {
    super.initState();

    // Only do this one time if the List is empty
    if (_speciesList.length == 0) {
      Future<List<Species>> futureList = _loadData();
      futureList.then((list) {
        setState(() {
          _speciesList = list;
        });
      });
    }
  }

  Future<List<Species>> _loadData() async {
    SpeciesDatabaseHelper speciesDBHelper = SpeciesDatabaseHelper();
    List<Species> futureList = await speciesDBHelper.getSpeciesList();
    return futureList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backGroundColor,
      appBar: AppBar(
        actions: <Widget>[
          _buildSearch(),
        ],
        title: Text(widget.title),
      ),
      body: _buildSpeciesListView(),
    );
  }

  Widget _loadImage(Species species,
      {double width = Constants.listViewImageWidth,
      double height = Constants.listViewImageWidth}) {
    return Hero(
        tag: species.title,
        child: Image.asset(
          species.imageFile,
          width: width,
          height: height,
        ));
  }

  Widget _buildSearch(){
    return IconButton(
      icon: Icon(Icons.search),
      onPressed:(){
        showSearch(
            context: context,
            delegate: DataSearch(speciesList: this._speciesList));
      },
    );
  }

  Widget _buildSpeciesListView() {
    return FutureBuilder<List<Species>>(
      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              //return  SpeciesListPageState.buildCellItem(context,this._speciesList,index);
              return  SpeciesListPageState.buildCellItem(context,this._speciesList,index);
            });
      },
    );
  }

  static Widget buildCellItem(
      BuildContext context,
      List<Species> list,
      int index,
      {
        CellType cellType = CellType.FittedBox,
        bool fromSearch = false,
      })
  {

    Species species = list[index];

    Widget widget;

    switch (cellType) {
      case CellType.Column:
        {
          break;
        }
      case CellType.FittedBox:
        {
          widget = GestureDetector(
              onTap: () {

                //if(fromSearch) LOMSharedPreferences.addToRecentSpeciesSearch(species);
                SpeciesListPageState.navigateToSpeciesDetails(context, species);

                /*Navigator.of(context).push(
                  PageRouteBuilder<Null>(
                      pageBuilder: (BuildContext context, Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return AnimatedBuilder(
                            animation: animation,
                            builder: (BuildContext context, Widget child) {
                              return Opacity(
                                opacity: animation.value,
                                child: SpeciesDetailsPage(
                                  species: species,
                                ),
                              );
                            });
                      },
                      transitionDuration: Duration(milliseconds: Constants.speciesHeroTransitionDuration)),
                );*/

                /*Navigator.of(context).push(
                    MaterialPageRoute(
                        fullscreenDialog: true, builder: (BuildContext context) => SpeciesDetailsPage(
                      species: species,
                    )));
                 */

                /*MaterialPageRoute(builder: (context) {
                    return SpeciesDetailsPage(
                      species: species,
                    );
                  }),
                );*/

              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                      child: Material(
                        elevation: 2.5,
                        borderRadius: BorderRadius.circular(Constants.speciesImageBorderRadius),
                        shadowColor: Colors.blueGrey,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Species.buildLemurPhoto(species),
                                  Container(width: 10),
                                  Species.buildTextInfo(species),
                                ])),
                      ))));

          break;
        }
      case CellType.ListTiles:
        {
          widget = Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Card(
                elevation: 1.5,
                child: ListTile(
                  leading: Species.buildLemurPhoto(species,imageClipper: SpeciesImageClipperType.oval),
                  title: Container(),
                  subtitle: Container(),
                ),
              ));
          break;
        }
    }

    return widget;
  }

  /*
  Widget _buildSpeciesGridList() {
    return FutureBuilder<List<Species>>(
      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return SpeciesListPageState.buildCellItem(context,this._speciesList,index);
            });
      },
    );
  }*/

  /*Widget _buildSpeciesGridList() {

    return ListView.builder(
        itemCount: _speciesList != null ? _speciesList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          Species species = _speciesList[index];

          return GestureDetector(
            child: Card(
              elevation: 2.5,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      species.imageFile,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.fill,
                    ),
                    Text(species.title),
                    Text(species.imageFile != null ? species.imageFile : "NULL")
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
        });
  }
  */


  static void navigateToSpeciesDetails(BuildContext context,Species species){

    Navigator.of(context).push(
      PageRouteBuilder<Null>(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: animation.value,
                    child: SpeciesDetailsPage(
                      species: species,
                    ),
                  );
                });
          },
          transitionDuration: Duration(milliseconds: Constants.speciesHeroTransitionDuration)),
    );

  }




}

class DataSearch extends SearchDelegate<List<Species>> {

  List<Species> speciesList   = List();
  List<Species> recentSpecies = List();
  List<Species> suggestionsList = List();

  initData() async{
    recentSpecies = await LOMSharedPreferences.loadRecentSpeciesSearch();
  }

  DataSearch({this.speciesList}){
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
    suggestionsList = query.isEmpty ? recentSpecies :
        
    speciesList.where((species) =>
            species.title.toLowerCase().contains(query.toLowerCase()) ||
            species.malagasy.toLowerCase().contains(query.toLowerCase()) ||
            species.french.toLowerCase().contains(query.toLowerCase()) ||
            species.german.toLowerCase().contains(query.toLowerCase()) ||
            species.english.toLowerCase().contains(query.toLowerCase()) ||
            species.otherEnglish.contains(query)
    ).toList();

    return ListView.builder(

      itemCount: suggestionsList.length,
      itemBuilder: (BuildContext context, int index) => SpeciesListPageState.buildCellItem(context,suggestionsList, index,fromSearch: true),

    );
  }

  Widget _buildSearchResult(){
    return ListView.builder(
        itemCount: this.suggestionsList.length,
        itemBuilder: (BuildContext context,int index){
          return SpeciesListPageState.buildCellItem(context,this.suggestionsList,index);
    });
  }

}
