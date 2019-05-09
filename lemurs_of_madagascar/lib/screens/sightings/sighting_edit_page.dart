import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:lemurs_of_madagascar/utils/camera/camera_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';


class SightingEditPage extends StatefulWidget {
  final String title;
  final Sighting sighting;

  SightingEditPage(this.title, this.sighting); //,{this.sighting});

  @override
  State<StatefulWidget> createState() {
    return _SightingEditPageState(
        this.title, this.sighting); //,sighting: this.sighting);
  }
}

class _SightingEditPageState extends State<SightingEditPage> {

  Sighting sighting;
  String title;
  List<String> imageFileNameList = List<String>();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EdgeInsets edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  EdgeInsets edgePadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);
  _SightingEditPageState(this.title, this.sighting);


  Species _currentSpecies;
  Future<List<Species>> _speciesList;


  @override
  void initState() {
    super.initState();
    _loadSpeciesList();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title, style: Constants.appBarTitleStyle),
      ),
      body: _buildBody(),
    );
  }

  _loadSpeciesList() async {
     SpeciesDatabaseHelper speciesDB = SpeciesDatabaseHelper();
     _speciesList = speciesDB.getSpeciesList();
     print(_speciesList);
     //_currentSpecies =  await_speciesList[0];

  }

  void _onChangedSpecies(Species species){
    setState(() {
      _currentSpecies = species;
    });
  }

  _buildBody() {
    final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

    return StreamBuilder<Sighting>(
        stream: bloc.outSighting,
        initialData: this.sighting,
        builder: (BuildContext context, AsyncSnapshot<Sighting> snapshot) {
          if (snapshot.data != null) {
            //print(snapshot.data);
            print("SNAPSHOT : ${snapshot.data.photoFileName}");

            return ListView(children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  Container(height: 20),
                  _buildPhotoSelection(snapshot.data),
                  _buildSpeciesDropDown(),
                  _buildImageListView(snapshot.data),
                ],
              ))
            ]);
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  _showCameraPage() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    try {
      final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

      Navigator.of(context).push(
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => BlocProvider(
                bloc: bloc, child: CameraPage(camera: firstCamera))),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildSpeciesDropDown(){

    return FutureBuilder<List<Species>>(

        future: _speciesList,

        builder: (BuildContext context, AsyncSnapshot<List<Species>> snapshot){

            if(snapshot.hasData) {

              return

                DropdownButton<Species>(

                  value: _currentSpecies,

                  items: snapshot.data.map((Species value) {
                    return DropdownMenuItem(

                        value: value,
                        child: Container(
                          width: MediaQuery.of(context).size.width -50,
                          height: 350,
                          child:Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Species.buildLemurPhoto(value),
                                Container(width: 5),
                                Species.buildTextInfo(value),
                              ]))
                        );


                  }).toList(),

                  onChanged: (Species value) {
                      _onChangedSpecies(value);
                  },

                );
            }

            return Center(child:Container(child:CircularProgressIndicator()));
         }
      );

  }

  _buildPhotoSelection(Sighting sighting) {
    return GestureDetector(
        onTap: () {
          //SpeciesListPageState.navigateToSpeciesDetails(context, species);
          _showCameraPage();
        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Container(
              child: Material(
                  elevation: 0.5,
                  borderRadius: BorderRadius.circular(0),
                  shadowColor: Colors.blueGrey,
                  //color: Constants.backGroundColor,
                  child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[_buildPhoto(sighting)]),
                        Container(width: 20),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                size: 45,
                                color: Constants.mainColor,
                              )
                            ]),
                      ])),
            )));
  }

  Widget _buildPhoto(Sighting sighting,
      {double size = Constants.cameraPhotoPlaceHolder,
      Color color = Constants.mainColor}) {
    if (sighting != null) {
      if (sighting.photoFileName == null) {
        return Container(
          child: Icon(
            Icons.image,
            size: size,
            color: color,
          ),
        );
      }

      return Container(
          child: Image.file(
        File(sighting.photoFileName),
        width: 200,
      ));
    }

    return Container();
  }

  _buildImageListView(Sighting sighting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 10.0,
        ),
        Container(
            child: Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  maxLines: 4,

                  onSaved: (val) => {},
                  /*validator: (String arg) {
                    if(arg.length < Constants.minUsernameLength) {
                      return ErrorText.loginNameError;
                    }else {
                      return null;
                    }
                  }*/
                  decoration: InputDecoration(
                      labelText: "Sighting title",
                      contentPadding: edgeInsets,
                      hintText: "Sighting title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) {} ,
                  /*validator: (String arg) {
                    if(arg.length == 0) {
                      return ErrorText.passwordError;
                    }else {
                      return null;
                    }
                  }*/
                  decoration: InputDecoration(
                      labelText: "Password",
                      contentPadding: edgeInsets,
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              )
            ],
          ),
        )),
      ],
    );
  }
}
