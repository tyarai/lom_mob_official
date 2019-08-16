import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/database/author_database_helper.dart';
import 'package:lemurs_of_madagascar/database/family_database_helper.dart';
import 'package:lemurs_of_madagascar/database/lom_map_database_helper.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/models/family.dart';
import 'package:lemurs_of_madagascar/models/lom_map.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/image.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xlive_switch/xlive_switch.dart';


abstract class SettingsPageContract {
  void onSyncSuccess();
  void onUpdatedSuccess(Map<String,dynamic> map);
  void onSyncFailure(int statusCode);
  void onSocketFailure();
}

class SettingsPagePresenter {
  SettingsPageContract _settingsView;
  RestData rest = RestData();
  SettingsPagePresenter(this._settingsView);

  sync(String settingsName, String settingsValue) {
    rest.syncSettings(settingsName, settingsValue)
        .then((success) {
          if(success){
            print("ATO1");
            _settingsView.onSyncSuccess();
          }else {
            print("ATO2");
          }
        })
        .catchError((error) {

          if(error is SocketException) _settingsView.onSocketFailure();
          if(error is LOMException) {
            _settingsView.onSyncFailure(error.statusCode);
          }
        });
  }

  getUpdatedNodes(DateTime fromDate) {
    rest.getUpdatedNodes(fromDate)
        .then((map) {
           //print("ATO1");
           _settingsView.onUpdatedSuccess(map);
      }).catchError((error) {

        if(error is SocketException) _settingsView.onSocketFailure();
        if(error is LOMException) {
          _settingsView.onSyncFailure(error.statusCode);
        }
    });
  }

}

class SettingsPage extends StatefulWidget {

  final String title;

  SettingsPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState(this.title);
  }

}

class SettingsPageState extends State<SettingsPage> implements SettingsPageContract  {

  String title;
  bool _value = false;
  bool _isLoading = false;
  SettingsPagePresenter presenter;
  static const _KEY_PUBLIC_SETTINGS = "public_list";


  SettingsPageState(this.title){
    presenter = SettingsPagePresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _loadPublicListSettings();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
          ],
          title: _buildTitle(),
        ),
        //body: SafeArea(child:_buildBody(context)),
        body: ModalProgressHUD(
            child: SafeArea(child:_buildBody(context)),
            opacity: 0.5,
            //color: Constants.mainSplashColor,
            progressIndicator: CircularProgressIndicator(),
            //offset: 5.0,
            //dismissible: false,
            inAsyncCall: _isLoading),
      );
  }

  Widget _buildTitle() {
    String title  = this.title;
    return Text(title);
  }


  Widget _buildBody(BuildContext buildContext){
    return Container(
      child: _buildSettingsListView(buildContext),
    );
  }

  Widget _buildSettingsListView(BuildContext buildContext) {

      return ListView(
        children:[
          ListTile(
            title: Column(children: <Widget>[
              Padding(padding: EdgeInsets.only(top:10),),
              Text("Make my sightings and lemur life list public", style: Constants.defaultTextStyle),
              Padding(padding: EdgeInsets.only(top:10),),
              Text("Other users can see your list on www.lemursofmadagascar.com", style: Constants.defaultSubTextStyle.copyWith(color: Colors.blueGrey)),

            ],),
            leading: SizedBox(width:40,height: 40,
              child: XlivSwitch(
                value: _value,
                onChanged: (bool value) {
                  //Navigator.pop(context); // Close the drawer
                  _changeValueStatus(buildContext);
                },),
            ),
            onTap: () {
              //Navigator.pop(context); // Close the drawer
              _changeValueStatus(buildContext);
            },
          ),
          Divider(height: 20,color: Colors.blueGrey,),
          ListTile(
            title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text("Tap to update database", style: Constants.defaultTextStyle),
              Padding(padding: EdgeInsets.only(top:10),),
              Text("Download new updates, species, families, photographs and maps from the server", style: Constants.defaultSubTextStyle.copyWith(color: Colors.blueGrey)),

              ],),
            leading:
              Icon(Icons.update,color: Constants.mainColor,),
            onTap: () {
              //Navigator.pop(context); // Close the drawer
              _getUpdateFromServer();
            },
          ),
          Divider(height: 20,color: Colors.blueGrey,),
        ]
      );

  }



  _getUpdateFromServer(){

    setState(() {
      _isLoading = true;
    });

    LOMSharedPreferences.loadString(LOMSharedPreferences.lastSyncDateTime).then((_lastDate) {
      DateTime fromDate;
      if (_lastDate != null && _lastDate.length != 0) {
        fromDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(_lastDate), isUtc: true);
      } else {
        //fromDate = DateTime.now().toUtc();
        fromDate = DateTime.parse(Constants.startDate).toUtc();
      }

      this.presenter.getUpdatedNodes(fromDate);

    });

  }

  _loadPublicListSettings() async {

    String publicListSettings = await LOMSharedPreferences.loadString(_KEY_PUBLIC_SETTINGS);
    _value = false;
    if(publicListSettings == "1" && publicListSettings != null ){
      setState(() {
        _value = true;
      });
    }

  }

  _changeValueStatus(BuildContext buildContext){

    String value = "0";

    setState(() {
      _value = !_value;
      _isLoading = true;
    });

    value = _value ? "1" : "0";

    presenter.sync(_KEY_PUBLIC_SETTINGS,value);


  }

  @override
  void onSocketFailure() {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handleSocketError(context);
  }

  @override
  void onSyncFailure(int statusCode) {
    setState(() {
      _isLoading = false;
    });
    ErrorHandler.handle(context, statusCode);
  }

  @override
  void onSyncSuccess() {


   String value = _value ? "1" : "0";

    LOMSharedPreferences.setString(_KEY_PUBLIC_SETTINGS,value).then((_){
      print("SUCCESS SETTINGS CHANGE to $value");
    });

    setState(() {
      _isLoading = false;
    });

  }


  @override
  void onUpdatedSuccess(Map<String,dynamic> map){
    //print("GOT MAP SUCCESS "+ map.toString());

    List<LOMMap> updatedMap= (map["maps"] as List).map((jsonMap){
      print("jsonMap "+jsonMap.toString());
      return LOMMap.fromMap(jsonMap);
    }).toList();

    List<Photograph> updatedPhotograph = (map["photographs"] as List).map((jsonPhoto){
      print("jsonPhoto "+jsonPhoto.toString());
      return Photograph.fromMap(jsonPhoto);
    }).toList();

    List<Family> updatedFamilies = (map["families"] as List).map((jsonFamily){
      print("jsonFamily "+jsonFamily.toString());
      return Family.fromMap(jsonFamily);
    }).toList();

    List<Site> updatedSites = (map["best_places"] as List).map((jsonSite){
      print("jsonSite "+jsonSite.toString());
      return Site.fromMap(jsonSite);
    }).toList();

    List<Author> updatedAuthors = (map["authors"] as List).map((jsonAuthor){
      print("jsonAuthor "+jsonAuthor.toString());
      return Author.fromMap(jsonAuthor);
    }).toList();

    List<Species> updatedSpecies = (map["species"] as List).map((jsonSpecies){
      print("jsonSpecies "+jsonSpecies.toString());
      return Species.fromMap(jsonSpecies);
    }).toList();


    _updateMap(updatedMap).then((_){
      _updatePhotograph(updatedPhotograph).then((_){
        _updateFamily(updatedFamilies).then((_){
          _updateSite(updatedSites).then((_){
              _updateAuthor(updatedAuthors).then((_){
                _updateSpecies(updatedSpecies).then((_){

                });
              });
            });
          });
        });
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateMap(List<LOMMap> mapList) async {

    if(mapList.length > 0){

      LOMMapDatabaseHelper db = LOMMapDatabaseHelper();

      for (LOMMap map in mapList) {

        db.getLOMMapWithID(id:map.nid).then((lommap) {

          if (lommap != null ) {
            // The map already exists in local database then update it
            map.saveToDatabase(true).then((savedMap) {

              if (savedMap == null) {
                print("[_updateMap()] Error: Map not updated on local database");
              } else {
                print("[_updateMap()] Success: Map updated on local database");
              }

            });

          } else {
            // The map  does not exist in local database then insert it
            map.saveToDatabase(false).then((savedMap) {
              if (savedMap == null) {
                print("[_updateMap()] Error: Map not inserted to local database");
              } else {
                print("[_updateMap()] Success: Map inserted to local database");
              }
            });
          }
        });


      }
    }
  }

  Future<void> _updatePhotograph(List<Photograph> photoList) async {

    if(photoList.length > 0){

      PhotographDatabaseHelper db = PhotographDatabaseHelper();

      for (Photograph photo in photoList) {

        db.getPhotographWithID(id:photo.id).then((_photo) {

          if (_photo != null ) {
            // The _photo already exists in local database then update it
            photo.saveToDatabase(true).then((savedPhoto) {

              if (savedPhoto == null) {
                print("[_updatePhotograph()] Error: Photo not updated on local database");
              } else {
                print("[_updatePhotograph()] Success: Photo updated on local database");
              }

            });

          } else {
            // The _photo  does not exist in local database then insert it
            photo.saveToDatabase(false).then((savedPhoto) {
              if (savedPhoto == null) {
                print("[_updatePhotograph()] Error: Photo not inserted to local database");
              } else {
                print("[_updatePhotograph()] Success: Photo inserted to local database");
              }
            });
          }
        });


      }
    }
  }

  Future<void> _updateFamily(List<Family> familyList) async {

    if(familyList.length > 0){

      FamilyDatabaseHelper db = FamilyDatabaseHelper();

      for (Family family in familyList) {

        db.getFamilyWithNID(nid:family.nid).then((_family) {

          if (_family != null ) {
            // The _family already exists in local database then update it
            family.saveToDatabase(true).then((savedFamily) {

              if (savedFamily == null) {
                print("[_updateFamily()] Error: Family not updated on local database");
              } else {
                print("[_updateFamily()] Success: Family updated on local database");
              }

            });

          } else {
            // The _photo  does not exist in local database then insert it
            family.saveToDatabase(false).then((savedFamily) {
              if (savedFamily == null) {
                print("[_updateFamily()] Error: Family not inserted to local database");
              } else {
                print("[_updateFamily()] Success: Family inserted to local database");
              }
            });
          }
        });


      }
    }
  }

  Future<void> _updateSite(List<Site> siteList) async {

    if(siteList.length > 0){

      SiteDatabaseHelper db = SiteDatabaseHelper();

      for (Site site in siteList) {

        db.getSiteWithNID(site.id).then((_site) {

          if (_site != null ) {
            // The _site already exists in local database then update it
            site.saveToDatabase(true).then((savedSite) {

              if (savedSite == null) {
                print("[_updateSite()] Error: Site not updated on local database");
              } else {
                print("[_updateSite()] Success: Site updated on local database");
              }

            });

          } else {
            // The _site  does not exist in local database then insert it
            site.saveToDatabase(false).then((savedSite) {
              if (savedSite == null) {
                print("[_updateSite()] Error: Site not inserted to local database");
              } else {
                print("[_updateSite()] Success: Site inserted to local database");
              }
            });
          }
        });


      }
    }
  }

  Future<void> _updateAuthor(List<Author> authorList) async {

    if(authorList.length > 0){

      AuthorDatabaseHelper db = AuthorDatabaseHelper();

      for (Author author in authorList) {

        db.getAuthorWithNID(nid:author.nid).then((_author) {

          if (_author != null ) {
            // The _author already exists in local database then update it
            author.saveToDatabase(true).then((savedAuthor) {

              if (savedAuthor == null) {
                print("[_updateAuthor()] Error: Author not updated on local database");
              } else {
                print("[_updateAuthor()] Success: Author updated on local database");
              }

            });

          } else {
            // The _site  does not exist in local database then insert it
            author.saveToDatabase(false).then((savedAuthor) {
              if (savedAuthor == null) {
                print("[_updateAuthor()] Error: Author not inserted to local database");
              } else {
                print("[_updateAuthor()] Success: Author inserted to local database");
              }
            });
          }

          LOMImage.downloadHttpImage(author.photo);

        });


      }
    }
  }

  Future<void> _updateSpecies(List<Species> speciesList) async {

    if(speciesList.length > 0){

      SpeciesDatabaseHelper db = SpeciesDatabaseHelper();

      for (Species species in speciesList) {

        print("UPDATED SPECIES "+ species.toString());

        db.getSpeciesWithID(species.id).then((_species) {

          if (_species != null ) {
            // The _species already exists in local database then update it
            species.saveToDatabase(true).then((savedSpecies) {

              if (savedSpecies == null) {
                print("[_updateSpecies()] Error: Species not updated on local database");
              } else {
                print("[_updateSpecies()] Success: Species updated on local database");
              }

            });

          } else {
            // The _site  does not exist in local database then insert it
            species.saveToDatabase(false).then((savedSpecies) {
              if (savedSpecies == null) {
                print("[_updateSpecies()] Error: Species not inserted to local database");
              } else {
                print("[_updateSpecies()] Success: Species inserted to local database");
              }
            });
          }
        });


      }
    }
  }

}

