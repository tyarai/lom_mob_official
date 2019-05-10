
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

typedef OnTapCallback();
typedef OnSelectCallback(SelectableListItem item);


Type typeOf<T>() => T;

abstract class SelectableListItem {

  Widget getItemCell(ListProvider provider, int index,BuildContext context, OnSelectCallback onSelectCallback,
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
    if(_listProvider.list != null && _listProvider.list.length == 0) {
      Future<List> futureList = _loadData();
      futureList.then((list) {
        setState(() {
          _listProvider.list = list;
        });
      });

    }

  }

  Future<List> _loadData() async {

    if( typeOf<T>() == typeOf<Species>()){
      SpeciesDatabaseHelper speciesDBHelper = SpeciesDatabaseHelper();
      List<Species> futureList = await speciesDBHelper.getSpeciesList();
      return futureList;

    }
    return null;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.backGroundColor,
      appBar: _buildAppBar(context),

      body: _buildBody(),)

    ;
  }

  Widget _buildBody(){

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:
      FutureBuilder(
        future: _loadData(),
        builder:(BuildContext context,AsyncSnapshot<List> snapshot) {

          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());


          SightingBloc bloc = BlocProvider.of<SightingBloc>(context);


          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {

                T item = _listProvider.getItemAt(index);

                OnSelectCallback onSelect = (item) {

                  setState(() {});
                  bloc.sightingEventController.add(SightingSpeciesChangeEvent(item));

                };

                return item.getItemCell(_listProvider,index, context, onSelect);
              });


        }
      ));

  }

  Widget _buildAppBar(BuildContext context){

    final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

    return AppBar(
        title: StreamBuilder<Sighting>(
          stream: bloc.outSighting,
          initialData: null,
          builder:(BuildContext context,AsyncSnapshot<Sighting> snapshot) {

            if(!snapshot.hasData || snapshot.data.title == null) return
                Text(this.title, style: Constants.appBarTitleStyle,);
            //TODO The AppBar titles is not yet updated
            return Text(snapshot.data.title, style: Constants.appBarTitleStyle,);
          }

      )
    );
  }
}


