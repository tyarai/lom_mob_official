import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:lemurs_of_madagascar/utils/camera/camera_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';


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



  List<Species> _speciesList = List<Species>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: Constants.mainColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(this.title, style: Constants.appBarTitleStyle),
      ),
      body: _buildBody(),
    );
  }


  void _onSpeciesChanged(Species species){

    if(species != null) {
      SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
      bloc.sightingEventController.add(SightingSpeciesChangeEvent(species));
    }

  }


  void _onTitleChanged(String value){

    if(value != null && value.length > 0) {
      SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
      bloc.sightingEventController.add(SightingTitleChangeEvent(value));
    }

  }



  _buildBody()  {
    final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

    return StreamBuilder<Sighting>(
        stream: bloc.outSighting,
        initialData: this.sighting,
        builder: (BuildContext context, AsyncSnapshot<Sighting> snapshot) {

          if (snapshot.data != null) {




            return ListView(
                children: <Widget>[

                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Material(
                      color: Colors.white,
                      elevation: 5.0,
                      borderRadius:
                      BorderRadius.circular(Constants.speciesImageBorderRadius),
                      shadowColor: Colors.blueGrey,
                      child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(height: 10),
                          _buildPhotoSelection(snapshot.data),
                          Container(height: 10,),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildSpeciesSelectButton(context,snapshot.data.species),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildSitesSelectButton(context,snapshot.data.site),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildImageListView(snapshot.data),
                ],
              )),
                    ),
                  )
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

  // Navigate to the Species select page
  _navigateToSpeciesSelectList(BuildContext context,ListProvider<Species> provider){

    SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return BlocProvider(
              bloc: bloc,
              child: ListProviderPage<Species>("Select species", provider)
          );
        }));
  }

  // Navigate to the Species select page
  _navigateToSiteSelectList(BuildContext context,ListProvider<Site> provider){

    SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return BlocProvider(
              bloc: bloc,
              child: ListProviderPage<Site>("Select site", provider)
          );
        }));
  }


  Widget _buildSpeciesSelectButton(BuildContext buildContext, Species species){

        OnTapCallback onTap = () {

          //TODO : Initialize the ListProvider.selected to the current Sighting.species in the stream
          ListProvider<Species> speciesListProvider = ListProvider();
          _navigateToSpeciesSelectList(buildContext,speciesListProvider);

        };

        if(species != null) {
          return  GestureDetector(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Container(
                    child: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.circular(0),
                      shadowColor: Colors.blueGrey,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Species.buildLemurPhoto(species,width: 100,height: 100),
                                Container(width: 10),
                                Species.buildTextInfo(species),
                                Container(width: 10),
                                _buildArrow(),

                              ])),
                    ))),
          );


        }

        return Container(
          child: ListTile(
            onTap: onTap,
            leading: Icon(Icons.pets),
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text("Select species",style: Constants.defaultTextStyle,),
        ));

  }


  _buildArrow(){
    return Container(
      child: Icon(Icons.arrow_forward_ios,size:25,color: Constants.mainColor,),
    );

  }

  Widget _buildSitesSelectButton(BuildContext buildContext,Site site){

    OnTapCallback onTap = () {

      ListProvider<Site> siteListProvider = ListProvider();
      _navigateToSiteSelectList(buildContext,siteListProvider);

    };

    if(site != null) {
      return  GestureDetector(
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Container(
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(0),
                  shadowColor: Colors.blueGrey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(width: 10),
                            Expanded(child:Column(children:<Widget>[Site.loadHeroTitle(site)])),
                            Container(width: 10),
                            _buildArrow(),

                          ])),
                ))),
      );
      /*return ListTile(
          onTap: onTap,
          trailing: Icon(Icons.arrow_forward_ios),
          title: Site.loadHeroTitle(site));*/

    }

    return Container(
        child: ListTile(
          onTap: onTap,
          leading: Icon(Icons.place),
          trailing: _buildArrow(),
          title: Text("Select site",style:Constants.defaultTextStyle),
        ));


  }

  /*Widget _buildSpeciesDropDown(){

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
                          height: 50,
                          child:Column(
                            children:<Widget> [Expanded(
                              child:Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Species.buildLemurPhoto(value),
                                    Container(width: 5),
                                    Species.buildTextInfo(value),
                                  ]),
                            ),
                          ]))
                        );


                  }).toList(),

                  onChanged: (Species value) {
                    _onSpeciesChanged(value);
                  },

                );
            }

            return Center(child:Container(child:CircularProgressIndicator()));
         }
      );

  }*/

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
                  elevation: 0,
                  borderRadius: BorderRadius.circular(0),
                  shadowColor: Colors.blueGrey,
                  color: Colors.transparent,
                  child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildPhoto(sighting)
                            ]
                        ),
                        /*Container(width: 20),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.camera_alt,
                                size: 45,
                                color: Constants.mainColor,
                              )
                            ]),*/
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
            Icons.camera,
            size: size,
            color: Constants.cameraPlaceHolderColor,
          ),
        );
      }

      return SizedBox(
        width: 250,
        height:200,
        child: Container(

            child: Image.file(
          File(sighting.photoFileName),
          //width: 200,
          //height:200,
        )),
      );
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
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  style: Constants.formDefaultTextStyle,
                  maxLines: 4,

                  onSaved: (val) => {
                    _onTitleChanged(val)
                  },

                  validator: (String arg) {

                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,

                  decoration: InputDecoration(
                      hintStyle: Constants.formHintTextStyle,
                      labelStyle: Constants.formLabelTextStyle,
                      labelText: "Title",
                      contentPadding: edgeInsets,
                      hintText: "give a title to your sighting",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  style: Constants.formDefaultTextStyle,
                  onSaved: (val) => {
                    _onTitleChanged(val)
                  },

                  validator: (String arg) {

                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                  decoration: InputDecoration(
                      hintStyle: Constants.formHintTextStyle,
                      labelStyle: Constants.formLabelTextStyle,
                      labelText: "Number observed",
                      contentPadding: edgeInsets,
                      hintText: "Number observed",

                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              Constants.speciesImageBorderRadius))),
                ),
              ),
              new Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  onSaved: (val) {} ,
                  /*validator: (String arg) {
                    if(arg.length == 0) {
                      return ErrorText.passwordError;
                    }else {
                      return null;
                    }
                  }*/
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Sighting date",
                      contentPadding: edgeInsets,
                      hintText: "Sighting date",
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

