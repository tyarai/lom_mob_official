import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:lemurs_of_madagascar/utils/error_text.dart';
import 'package:lemurs_of_madagascar/utils/location/gps_location.dart';
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:lemurs_of_madagascar/utils/camera/camera_page.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/utils/providers/object_select_provider.dart';
import 'package:location/location.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class SightingEditPage extends StatefulWidget {
  final String title;
  final bool editing;
  final Sighting sighting;

  SightingEditPage(this.title, this.sighting,this.editing); //,{this.sighting});

  @override
  State<StatefulWidget> createState() {
    return _SightingEditPageState(
        this.title, this.sighting,this.editing); //,sighting: this.sighting);
  }
}

class _SightingEditPageState extends State<SightingEditPage> implements SyncSightingContract {

  final bool _editing;
  Sighting sighting;
  String title;
  bool _isLoading = false;
  List<String> imageFileNameList = List<String>();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EdgeInsets edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
  EdgeInsets edgePadding = EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0);

  SyncSightingPresenter syncPresenter;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _countController = TextEditingController();


  _SightingEditPageState(this.title, this.sighting,this._editing){
      syncPresenter = SyncSightingPresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _countController.dispose();
  } //List<Species> _speciesList = List<Species>();


  @override
  void initState() {
    super.initState();
    _titleController.text = this.sighting.title != null ? this.sighting.title : "";
    _countController.text = this.sighting.speciesCount != null ? this.sighting.speciesCount.toString() : "";
    _titleController.addListener(_onTitleChanged);
    _countController.addListener(_onNumberChanged);
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: Constants.mainColor,
      appBar: AppBar(
        actions: <Widget>[
            IconButton(
            iconSize: Constants.iconSize,
            icon:  Icon(Icons.save,color: Constants.iconColor,),
            onPressed: () {
              _submit(buildContext);
            },
          ),
        ],
        elevation: 0,
        title: Text(this.title, style: Constants.appBarTitleStyle),
      ),
      body: ModalProgressHUD(
          child:_buildBody(buildContext),
          opacity: 0.5,
          //color: Constants.mainSplashColor,
          //progressIndicator: CircularProgressIndicator(),
          //offset: 5.0,
          //dismissible: false,
          inAsyncCall: _isLoading
        )


    );
  }


  void _onSpeciesChanged(Species species){

    if(species != null) {
      SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
      bloc.sightingEventController.add(SightingSpeciesChangeEvent(species));
    }

  }


  void _onTitleChanged(){

      SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
      bloc.sightingEventController.add(SightingTitleChangeEvent(_titleController.text));

  }

  void _onNumberChanged(){

    int value = 0;

    try {
      value = int.parse(_countController.text);
    }catch(e){
      _countController.clear();
    }

    if (value >= 0) {
      SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
      bloc.sightingEventController.add(SightingNumberObservedChangeEvent(value));
    }


  }

  bool _validateSighting(BuildContext context){

    SightingBloc bloc = BlocProvider.of<SightingBloc>(context);
    Sighting sightingToSave = bloc.sighting;
    print("VALIDATE" + sightingToSave.toString());

    if(sightingToSave.species == null){

      showAlert(context: context,title: this.title,body:ErrorText.noSpeciesError,actions: []);
      return false;
    }
    if(sightingToSave.site == null){

      showAlert(context: context,title: this.title,body:ErrorText.noSiteError,actions: []);
      return false;
    }

    return true;

  }

  Future<void> _navigateToPreviousPage() async{
    Navigator.of(context).pop();
    //Navigator.of(context).pushReplacementNamed("/sighting_list");
  }

  _buildBody(BuildContext buildContext)   {

    final SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);

    return StreamBuilder<Sighting>(
        stream: bloc.outSighting,
        //initialData: initialSighting,
        initialData: this.sighting,
        builder: (BuildContext context, AsyncSnapshot<Sighting> snapshot)  {

          if (snapshot.data != null && snapshot.hasData) {

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
                          _buildPhotoSelection(snapshot.data,buildContext),
                          Container(height: 10,),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildSpeciesSelectButton(buildContext,snapshot.data.species),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildSitesSelectButton(buildContext,snapshot.data.site),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildDatePicker(bloc,snapshot.data),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildFormInput(snapshot.data),
                          Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                          _buildGPSWidget(bloc,snapshot.data),
                        ],
                      )),
                    ),
                  )
            ]);
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildDatePicker(SightingBloc bloc, Sighting sighting){

    DateTime date = DateTime.now();

    if (sighting.date != null && sighting.date != 0.0){
        date = DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt());
    }

    String formattedDate = DateFormat.yMMMMd("en_US").format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget> [

            ListTile(
              onTap: () {

                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime.now(),
                    onChanged: (date) {
                      //print('change $date');
                    }
                    ,
                    onConfirm: (date) {
                      double newDate = date.millisecondsSinceEpoch.toDouble();
                      bloc.sightingEventController.add(SightingDateChangeEvent(newDate));
                    },
                    currentTime: date,
                    locale: LocaleType.en);

              },
              leading: Icon(Icons.calendar_today),
              trailing: Icon(Icons.arrow_drop_down),
              title: Text(formattedDate,style: Constants.defaultTextStyle,)
           )

    ]
    );

  }

  _buildGPSWidget(SightingBloc bloc,Sighting sighting){

  double long = 0.0;
  double lat = 0.0;
  double alt = 0.0;

  if(sighting != null) {

    long = sighting.longitude != null ? sighting.longitude : 0.0;
    lat  = sighting.latitude != null ? sighting.latitude : 0.0;
    alt  = sighting.altitude != null ? sighting.altitude : 0.0;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child:_getUpdateLocationButton(bloc),
            ),
            Container(
                child:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[


                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Expanded(flex:1,child:Text("Longitude",style: Constants.defaultSubTextStyle.copyWith(fontWeight: FontWeight.w700),)),
                            Expanded(flex:1,child:Text(long.toStringAsPrecision(Constants.gpsPrecision),style: Constants.defaultSubTextStyle,)),
                          ]
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Expanded(flex:1,child:Text("Latitude",style: Constants.defaultSubTextStyle.copyWith(fontWeight: FontWeight.w700),)),
                          Expanded(flex:1,child:Text(lat.toStringAsPrecision(Constants.gpsPrecision),style: Constants.defaultSubTextStyle,)),
                        ]
                      ),
                      Padding(padding: EdgeInsets.only(top:5),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          Expanded(flex:1,child:Text("Altitude",style: Constants.defaultSubTextStyle.copyWith(fontWeight: FontWeight.w700),)),
                          Expanded(flex:1,child:Text(alt.toStringAsPrecision(Constants.gpsPrecision),style: Constants.defaultSubTextStyle,)),
                        ]
                      ),
            ]),
                )),

          ],
        ),
      ),
    );
  }
  return Container();
}

  _getUpdateLocationButton(SightingBloc bloc) {
    return Container(
      width:MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex:1,
            //crossAxisAlignment: CrossAxisAlignment.start,
            child: OutlineButton(
              padding: EdgeInsets.all(5),
              child: Text("update GPS location",textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: Constants.flatButtonTextStyle
                      .copyWith(color: Constants.mainColor)),
              onPressed: () {

                Future<LocationData> locationData = GPSLocation.getOneTimeLocation();

                if(locationData != null){

                  locationData.then((_locationData){
                    if(_locationData != null) {
                      bloc.sightingEventController.add(
                          SightingLocationChangeEvent(
                              longitude: _locationData.longitude,
                              latitude: _locationData.latitude,
                              altitude: _locationData.altitude));
                    }
                  });

                }

              }, //callback when button is clicked
              borderSide: BorderSide(
                color: Constants.registerBtnBorderColor, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: 0.5, //width of the border
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 10),),
          Expanded(
            flex:1,
            //crossAxisAlignment: CrossAxisAlignment.end,
            child: OutlineButton(
              padding: EdgeInsets.all(5),
              child: Text("clear GPS location",textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: Constants.flatRedButtonTextStyle
                      .copyWith(color: Colors.red)),
              onPressed: () {

                bloc.sightingEventController.add(SightingLocationChangeEvent(longitude:0.0, latitude: 0.0, altitude: 0.0));


              }, //callback when button is clicked
              borderSide: BorderSide(
                color: Colors.red, //Color of the border
                style: BorderStyle.solid, //Style of the border
                width: 0.5, //width of the border
              ),
            ),
          ),
      ]
      ),
    );
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


  /* _buildSpeciesSelectButton(BuildContext buildContext, Sighting _sighting){

    OnTapCallback onTap = () {
      //TODO : Initialize the ListProvider.selected to the current Sighting.species in the stream
      ListProvider<Species> speciesListProvider = ListProvider();
      _navigateToSpeciesSelectList(buildContext,speciesListProvider);

    };

    Species species = _sighting.species;


    return  GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: FutureBuilder<bool>(
          future:_sighting.loadSpeciesAndSite(),
          builder:(context,snapshot){

             if(snapshot.data == null || ! snapshot.hasData){

               return Container(
                 child: ListTile(
                   onTap: onTap,
                   leading: Icon(Icons.pets),
                   trailing: Icon(Icons.arrow_forward_ios),
                   title: Text("Select species",style: Constants.defaultTextStyle,),
                 ));
             }

             return Container(
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

            ));
          }))
      );
  } */

  _buildSpeciesSelectButton(BuildContext buildContext, Species species){

    OnTapCallback onTap = () {
      //TODO : Initialize the ListProvider.selected to the current Sighting.species in the stream
      ListProvider<Species> speciesListProvider = ListProvider();
      _navigateToSpeciesSelectList(buildContext,speciesListProvider);

    };

    //SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
    //Species species = bloc.sighting.species;


    if(species != null) {
      return GestureDetector(
        onTap: onTap,
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
                  Species.buildLemurPhoto(
                      species, width: 100, height: 100),
                  Container(width: 10),
                  Species.buildTextInfo(species),
                  Container(width: 10),
                  _buildArrow(),

                ])),

          )
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Container(
          child: ListTile(
            onTap: onTap,
            leading: Icon(Icons.pets),
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text(
              "Select species", style: Constants.defaultTextStyle,),
          )
        )
      )
    );


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


    }

    return Container(
        child: ListTile(
          onTap: onTap,
          leading: Icon(Icons.place),
          trailing: _buildArrow(),
          title: Text("Select site",style:Constants.defaultTextStyle),
        ));


  }

  _buildPhotoSelection(Sighting sighting,BuildContext buildCOntext)   {
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
                         _buildPhoto(sighting,buildCOntext)
                      ]
                  ),

                ])),
          )));
  }

  _buildPhoto(Sighting sighting,BuildContext buildCOntext,
      {double size = Constants.cameraPhotoPlaceHolder,
        Color color = Constants.mainColor})  {

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

      return
        SizedBox(
          width: 250,
          height:200,
          child: FutureBuilder<Container>(
            //future: Sighting.getImage(sighting),
            future: Sighting.getImageContainer(sighting,buildCOntext),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }
              return snapshot.data;
            }
          ));

    }

    return Container();
  }

  _buildFormInput(Sighting sighting) {

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
                        controller: _titleController,
                        style: Constants.formDefaultTextStyle,
                        maxLines: 4,
                        //initialValue: sighting.title,
                        onSaved: (val) => {
                          //_onTitleChanged(val)
                        },

                        validator: (String arg) {
                          if(arg == null || arg.length == 0 ){
                            return ErrorText.emptyString;
                          }
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,

                        decoration: InputDecoration(
                            hintStyle: Constants.formHintTextStyle,
                            labelStyle: Constants.formLabelTextStyle,
                            labelText: "Sighting title",
                            contentPadding: edgeInsets,
                            //hintText: "give a title to your sighting",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.speciesImageBorderRadius))),
                      ),
                    ),
                    Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                    new Padding(
                      padding: EdgeInsets.all(10),
                      child: new TextFormField(
                        controller: _countController,
                        style: Constants.formDefaultTextStyle,
                        onSaved: (val) => {
                          //_onNumberChanged(val)
                        },

                        validator: (String arg) {
                          if(arg == null || arg.length == 0 || int.parse(arg) <= 0){
                            return ErrorText.invalidIntegerNumber;
                          }
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                        decoration: InputDecoration(
                            hintStyle: Constants.formHintTextStyle,
                            labelStyle: Constants.formLabelTextStyle,
                            labelText: "Number observed",
                            contentPadding: edgeInsets,
                            //hintText: "Number observed",

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.speciesImageBorderRadius))),
                      ),
                    ),
                    Divider(height: Constants.listViewDividerHeight,color: Constants.listViewDividerColor),
                  ],
                ),
              )),
        ],
      );
    }

  _submit(BuildContext buildContext) async {

    final form = formKey.currentState;

    if(_validateSighting(buildContext)) {

      if (form.validate()) {

        setState(() {
          _isLoading = true;
        });

        form.save();
        SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
        Sighting currentSighting = bloc.sighting;

        currentSighting.saveToDatabase(this._editing).then((savedSighting){

          //this._navigateToPreviousPage();

          if (savedSighting != null){

             bloc.sightingEventController.add(SightingChangeEvent(savedSighting));
             syncPresenter.sync(savedSighting,editing:this._editing);
          }

        }).catchError((error){
          print("[Sighting_edit_page::_submit()] Exception ${error.toString()}");
          throw error;
        });

      }

    }
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
  void onSyncSuccess(Sighting sighting,int nid,bool editing) {


    setState(() {
      _isLoading = false;
    });

    // Update this sighting nid which was from the server
    if(nid > 0 && sighting != null) {

      //print("SIGHTING BEFORE SAVE "+ sighting.toString());

      sighting.nid = nid;

      if(! editing) {
        // Only update nid when inserting operation. The return value from updateFunction
        //sighting.nid = nid;
      }

        // Always use 'true' as editing because we are going to update the nid
        sighting.saveToDatabase(true).then((savedSightingWithNewNID) {

          if(savedSightingWithNewNID != null) {



            this._navigateToPreviousPage();

            /*if(editing) {
              print(
                  "[SIGHTING_EDIT_PAGE::onSyncSuccess()] updated sighting : ${sighting
                      .toString()}");
            }else{
              print(
                  "[SIGHTING_EDIT_PAGE::onSyncSuccess()] created new sighting : ${sighting
                      .toString()}");
            }*/

          }else{
            print(
                "[SIGHTING_EDIT_PAGE::onSyncSuccess()] updated/creation not completed");
          }

        });

    }

  }

}


