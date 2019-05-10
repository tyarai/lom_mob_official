
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';


typedef OnTapCallback(BuildContext context,T);

abstract class ListProvider<T> {

  List<T> list;
  T selectedItem;
  int selectedItemIndex;

  T getItemAt(int index);

  Widget getItemCell(T item,int index,BuildContext context,OnTapCallback onTap,
      {
        double borderRadius = Constants.speciesImageBorderRadius,
          double elevation    = 2.5,
        double imageWidth   = Constants.listViewImageWidth,
        double imageHeight  = Constants.listViewImageHeight,
        SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular

      });


}

class SpeciesListProvider implements ListProvider<Species>{

  @override
  List<Species> list ;

  @override
  Species selectedItem;

  @override
  int selectedItemIndex;


  SpeciesListProvider(this.list){
    selectedItem = null;
    selectedItemIndex = -1;
  }

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

  @override
  Species getItemAt(int index) => (index >= 0 && index < list.length) ? list[index] : null;

}

class ListProviderPage<T> extends StatefulWidget {

  final String title;

  ListProviderPage(this.title);

  @override
  State<StatefulWidget> createState() {
    return _ListProviderPageState<Species>(title);

  }

}

class _ListProviderPageState<T> extends State<ListProviderPage> {

  String title;
  ListProvider<T> listProvider;


  _ListProviderPageState(this.title);


  @override
  void initState() {

    super.initState();

    if(T is Species) {
      Future<List<Species>> list = loadData();

      list.then((_list){
        SpeciesListProvider provider = SpeciesListProvider(_list);
        listProvider = provider as ListProvider;
      });
    }
  }

  Future<List> loadData() async {
    if (T is Species){
      SpeciesDatabaseHelper speciesDatabaseHelper = SpeciesDatabaseHelper();
      return await speciesDatabaseHelper.getSpeciesList();
    }
    return List();
  }

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
          itemCount: listProvider.list.length,
          itemBuilder: (BuildContext context, int index) {

            T item = listProvider.getItemAt(index);

            return  listProvider.getItemCell(item, index, context, null);

    }));

  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text(this.title,style: Constants.appBarTitleStyle,)
    );
  }




}
