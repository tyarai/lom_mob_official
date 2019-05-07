import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:lemurs_of_madagascar/utils/camera/camera_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';

class SightingEditPage extends StatefulWidget {
  final String title;
  final Sighting sighting;

  SightingEditPage({this.title, this.sighting});

  @override
  State<StatefulWidget> createState() {
    return _SightingEditPageState(this.title, this.sighting);
  }
}

class _SightingEditPageState extends State<SightingEditPage> {

  String title;
  Sighting sighting;
  List<String> imageFileNameList = List<String>();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EdgeInsets edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  EdgeInsets edgePadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);


  _SightingEditPageState(this.title, this.sighting);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    /*return ListView(
        children : <Widget> [
          Container(
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height,
            child:Column(
              children: <Widget>[
                Container(height:20),
                _buildPhotoSelectionRow(),
                _buildImageListView(),
              ],
            )
          )
        ],
    );*/

    return StreamBuilder(
        stream: _sightingBloc.sighting,
        initialData: Sighting(),
        builder: (BuildContext context, AsyncSnapshot<Sighting> snapshot) {

          ListView(children: <Widget>[
            Container(
                child: Column(
              children: <Widget>[
                Container(height: 20),
                _buildPhotoSelection(snapshot.data),
                _buildImageListView(),
              ],
            ))
          ]);
        });
  }

  _showCameraPage() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    try {
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => CameraPage(camera: firstCamera)));
    } catch (e) {
      print(e.toString());
    }
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildPhoto(sighting),
                        Container(width: 10),
                        Icon(
                          Icons.camera_alt,
                          size: 45,
                          color: Constants.mainColor,
                        ),
                      ])),
            )));
  }

  Widget _buildPhoto(Sighting sighting,
      {double size = Constants.cameraPhotoPlaceHolder,
      Color color = Constants.mainColor}) {

    if (sighting.photoFileName == null) {
      return Container(
        child: Icon(
          Icons.image,
          size: size,
          color: color,
        ),
      );
    }

    //TODO replace Text widget with Image widget
    return Container(
      child: Text(sighting.photoFileName),
    );
  }

  _buildImageListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50.0,
        ),
        Container(
            child: Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              /*new Padding(
                padding: edgePadding,
                child: new TextFormField(
                  onSaved: (val) => {},
                  /*validator: (String arg) {
                    if(arg.length < Constants.minUsernameLength) {
                      return ErrorText.loginNameError;
                    }else {
                      return null;
                    }
                  }*/
                  decoration: InputDecoration(
                      labelText: "Username",
                      icon: new Icon(
                        Icons.person,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Username",
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
                      icon: new Icon(
                        Icons.lock,
                        color: Constants.iconColor,
                      ),
                      contentPadding: edgeInsets,
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              )*/
            ],
          ),
        )),
      ],
    );
  }
}
