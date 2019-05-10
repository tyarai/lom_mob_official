
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';


typedef OnTapCallback(BuildContext context,T);


abstract class SelectableListItem {

  Widget getItemCell(int index,BuildContext context, OnTapCallback onTap,
  {
    double borderRadius = Constants.speciesImageBorderRadius,
    double elevation    = 2.5,
    double imageWidth   = Constants.listViewImageWidth,
    double imageHeight  = Constants.listViewImageHeight,
    SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular
  });

}


class ListProvider<T extends SelectableListItem> {

  List<T> _list = List<T>();
  T selectedItem;
  int selectedItemIndex;


  ListProvider(){
    resetSelectedItem();
  }

  set list(List<T> list) {
    this._list = list;
  }

  List<T> get list => this._list;

  void resetSelectedItem(){
    selectedItemIndex = -1;
    selectedItem      = null;
  }

  /*
  @override
  Widget getItemCell(Species species,int index,BuildContext context, OnTapCallback onTap,
      {
        double borderRadius = Constants.speciesImageBorderRadius,
        double elevation    = 2.5,
        double imageWidth   = Constants.listViewImageWidth,
        double imageHeight  = Constants.listViewImageHeight,
        SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular
      })
  {
    return GestureDetector(
        onTap: () {

          //SpeciesListPageState.navigateToSpeciesDetails(context, species);
          onTap(context,species);
          selectedItem = species;
          selectedItemIndex = index;

        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Container(
                child: Material(
                  elevation: elevation,
                  borderRadius: BorderRadius.circular(borderRadius),
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Species.buildLemurPhoto(species,width: imageWidth,height: imageHeight,imageClipper: imageClipper),
                            Container(width: 10),
                            Species.buildTextInfo(species),
                            Container(width: 10),
                            (selectedItemIndex == index) ? Container(
                              child: Icon(Icons.check,color: Colors.greenAccent,),
                            ) : Container(),

                          ])),
                ))));

  }
  */

  T getItemAt(int index) => (index >= 0 && index < _list.length) ? _list[index] : null;

}

class ListProviderPage<T extends SelectableListItem> extends StatefulWidget {

  final String title;
  final ListProvider<T> listProvider;

  ListProviderPage(this.title,this.listProvider);

  @override
  State<StatefulWidget> createState() {
    return _ListProviderPageState<T>(title,this.listProvider);
  }

}

class _ListProviderPageState<T extends SelectableListItem> extends State<ListProviderPage> {

  String title;
  ListProvider<T> _listProvider ;


  _ListProviderPageState(this.title,this._listProvider);

  @override
  void initState() {

    super.initState();
    //loadData();
  }

  /*void loadData() async {
    if (T is Species && listProvider.list.length == 0){
      SpeciesDatabaseHelper speciesDatabaseHelper = SpeciesDatabaseHelper();
      List<Species> speciesList =   await speciesDatabaseHelper.getSpeciesList();
      listProvider.list = speciesList;
    }

  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: _buildAppBar(),

      body: _buildBody(),)

    ;
  }

  Widget _buildBody(){

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:
      ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _listProvider.list.length,
          itemBuilder: (BuildContext context, int index) {

            T item = _listProvider.getItemAt(index);

            return  item.getItemCell(index, context, null);

    }));

  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text(this.title,style: Constants.appBarTitleStyle,)
    );
  }




}
