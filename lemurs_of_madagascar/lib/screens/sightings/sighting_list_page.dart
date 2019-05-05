
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/screens/species_list/species_list_page.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';


class SightingListPage extends StatefulWidget {

  final String title;

  SightingListPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return _SightingListPageState(this.title);
  }

}

class _SightingListPageState extends State<SightingListPage> {

  String title;
  int currentUid = 0;
  List<Sighting> sightingList = List<Sighting>();


  @override
  initState()  {
    super.initState();


    try {

      if (currentUid == 0) {

        Future<String> _currentUid = LOMSharedPreferences.loadString(
            Sighting.uidKey);
        _currentUid.then((currentUID) {

          if(currentUID != null) {

            currentUid = int.parse(currentUID);

            if(sightingList.length == 0) {
              Future<List<Sighting>> futureList = _loadData(currentUid);
              futureList.then((list) {
                setState(() {
                  sightingList = list;
                });
              });
            }

          }else{
            //TODO : The user is not connected. Redirect to login page
          }

        });

      }

    }catch(e){
      print(e.toString());
    }

  }

  _SightingListPageState(this.title);

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
      body: _buildSightingListView(),
    );
  }

  Widget _buildSearch(){
    return IconButton(
      icon: Icon(Icons.search),
      onPressed:(){
        /*showSearch(
            context: context,
            delegate: DataSearch(speciesList: this._speciesList));*/
      },
    );
  }

  Widget _buildSightingListView() {
    return FutureBuilder<List<Sighting>>(
      future: _loadData(this.currentUid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              //return  SpeciesListPageState.buildCellItem(context,this._speciesList,index);
              return  _SightingListPageState.buildCellItem(context,this.sightingList,index);
            });
      },
    );
  }

  Future<List<Sighting>> _loadData(int uid) async {
    if(uid != null) {
      SightingDatabaseHelper sightingDBHelper = SightingDatabaseHelper();
      List<Sighting> futureList = await sightingDBHelper.getSightingList(uid);
      return futureList;
    }
    return null;
  }


  static Widget buildCellItem(BuildContext context,List<Sighting> list,int index)
  {

    Sighting sighting = list[index];

    return GestureDetector(
      onTap: () {
        //SpeciesListPageState.navigateToSpeciesDetails(context, sighting);
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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Sighting.buildSightingPhoto(sighting),
                          Container(height: 10),
                          Sighting.buildTextInfo(sighting),
                        ])),
    ))));

  }
}