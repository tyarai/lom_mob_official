import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:flutter_alert/flutter_alert.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;


  const CameraPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraPageState createState() =>  CameraPageState();
}

class CameraPageState extends State<CameraPage> {

  // Add two variables to the state class to store the CameraController and
  // the Future
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String path = "";
  Future<File> imageFile;
  int _currentUID;
  String _newFileName = "";


  @override
  void initState() {

    super.initState();
    // In order to display the current output from the Camera, you need to
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras
      widget.camera,
      // Define the resolution to use
      ResolutionPreset.medium,
    );

    

    this._currentUID =  0;

    // Next, you need to initialize the controller. This returns a Future
    _initializeControllerFuture = _controller.initialize();

    _initializeControllerFuture.then((controller){

      Future<User> user = User.getCurrentUser();

      user.then((user){

        if(user != null){
          this._currentUID = user.uid;
        }

      });

    }).catchError((error){

       if(error is CameraException){

         //showAlert(context: context,title: "Camera",body: error.toString(),actions: []);
         print("[CAMERA_PAGE::initState()] Error "+ error.toString());

       }

    });

    /*

    Future<int> currentUID = UserSession.loadCurrentUserUID();
    this._currentUID =  0;
    currentUID.then((uid){
       this._currentUID =  uid;
    });

    */

  }


  Future<String> copyFileToDocuments(int currentUID,{File oldFile,String ext = Constants.imageType}) async {

    String newFilePath =  (await getApplicationDocumentsDirectory()).path;

    this._newFileName  = "$currentUID-${DateTime.now()}";
    this._newFileName  = this._newFileName.replaceAll(":", "-");
    this._newFileName  = this._newFileName.replaceAll(" ", "-");
    this._newFileName  = this._newFileName.replaceAll(".", "-");
    this._newFileName  = this._newFileName + "." + ext;

    newFilePath = join(newFilePath, this._newFileName);

    if(oldFile != null && oldFile.existsSync()) {

      return oldFile.copy(newFilePath).then((_newFile){

        print("[CAMERA_PAGE::copyFileToDocuments()] file copied to " + _newFile.path);
        String oldPath = oldFile.path;
        oldFile.deleteSync();
        print("[CAMERA_PAGE::copyFileToDocuments()] old file deleted " + oldPath);

        return _newFile.path;

      });

    }

    return newFilePath;

  }

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    _controller.dispose();
    print("[CAMERA_PAGE::initState()] Disposed camera controller ");
    super.dispose();
  }

   _pickImageFromGallery(ImageSource source) async {

    try {

      setState(() {
        this.imageFile = ImagePicker.pickImage(source: source);
      });

    }catch(e){
      print("[CAMERA_PAGE::_pickImageFromGallery()] Error :"+e.toString());
      throw e;
    }
  }

  handleImage(BuildContext context) async {

    _pickImageFromGallery(ImageSource.gallery);

      this.imageFile.then((file){

      if(file != null) {

        final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

        Future<String> newFileName = copyFileToDocuments(this._currentUID,oldFile: file);

        newFileName.then((_newFilePath){

          //print("HERE "+_newFilePath);

          if(_newFilePath != null) {

            print("[CAMERA_PAGE::handleImage()] - Image picker new file :" + _newFilePath);

            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) =>
                    BlocProvider(
                        bloc: bloc,
                        //child: DisplayPictureScreen(imagePath: file.path))),
                        child: DisplayPictureScreen(_newFilePath,this._newFileName))),
            );
          }

        });


      }

    }).catchError((error){

      showAlert(context: context,title: "Camera",body: error.toString(),actions: []);

    });


  }

  _buildAppBar(BuildContext buildContext){
    return
      AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: Icon(Icons.photo_album,size: 40,color: Constants.iconColor,),
              onPressed: () {

                handleImage(buildContext);

              },
            ),
          ),
        ],
        title: Text('Take a picture',style:Constants.appBarTitleStyle)
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return true;
      }
      ,
      child: Scaffold(

        appBar: _buildAppBar(context),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until
        // the controller has finished initializing
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator
              return Center(child: CircularProgressIndicator());
            }
          },
        ),

        floatingActionButton:
            FloatingActionButton(

            child: Icon(Icons.photo_camera),
            // Provide an onPressed callback
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure the camera is initialized
                await _initializeControllerFuture;

                // Construct the path where the image should be saved using the path
                // package.
                // In this example, store the picture in the temp directory. Find
                // the temp directory using the `path_provider` plugin.

                //path = join((await getApplicationDocumentsDirectory()).path,"${this._currentUID}-${DateTime.now()}.${Constants.imageType}",);
                path = await copyFileToDocuments(this._currentUID);
                //print("SAVE IMAGE TO $path");

                // Attempt to take a picture and log where it's been saved

                await _controller.takePicture(path);

                final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

                // If the picture was taken, display it on a new screen

                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) =>
                        BlocProvider(
                            bloc: bloc,
                            child: DisplayPictureScreen(path,this._newFileName))),
                );

              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),

      ),
    );

  } // Fill this out in the next steps

}

// A Widget that displays the picture taken by the user
/* class DisplayPictureScreen extends StatelessWidget {

  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return WillPopScope(

      onWillPop: () async {
        print("preview screen will pop");
        _close(context,delete: true);
        return true; //

      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image
        body:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: <Widget>[
              Image.file(File(imagePath)),
            ]),
          ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext buildContext) {

    return AppBar(
        title: Text("Preview",style:Constants.appBarTitleStyle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt,size: 40,color: Constants.iconColor,),
            onPressed: () {
             _close(buildContext,delete: true);
            },
          ),
          Container(width:10),
          IconButton(
            icon: Icon(Icons.save,size:40,color: Constants.iconColor,),
            onPressed: () {
              _selectImage(buildContext);
            },
          ),
    ]);
  }

  _close(BuildContext buildContext,{bool delete = false}){
    if(imagePath.length != 0) {
      File file = File(imagePath);
      if(file.existsSync()) {
        if(delete) {
          file.deleteSync();
          print("Preview screen - deleted " + imagePath);
        }
      }
    }
    Navigator.of(buildContext).pop();
  }

  _selectImage(BuildContext buildContext){

    SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
    //File file = File(this.imagePath);
    bloc.sightingEventController.add(SightingImageChangeEvent(this.imagePath));
    Navigator.of(buildContext).pop();
    Navigator.of(buildContext).pop();

  }
} */


class DisplayPictureScreen extends StatefulWidget {

  final String imagePath;
  final String _newFileName; // Filename with no path

  DisplayPictureScreen(this.imagePath,this._newFileName);


  @override
  State<StatefulWidget> createState() {
    return _DisplayPictureScreenState(this.imagePath,this._newFileName);
  }



}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  final String imagePath;
  final String _newFileName;
  bool gotImage = false;

  _DisplayPictureScreenState(this.imagePath,this._newFileName);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: () async {
        //print("preview screen will pop");
        _close(context,this.gotImage);
        return true; //

      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image
        body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: <Widget>[
            Image.file(File(imagePath)),
          ]),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext buildContext) {

    return AppBar(
        title: Text("Preview",style:Constants.appBarTitleStyle),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.camera_alt,size: 40,color: Constants.iconColor,),
            onPressed: () {
              //_close(buildContext,this.gotImage);
              Navigator.of(buildContext).pop();
            },
          ),*/
          Container(width:10),
          IconButton(
            icon: Icon(Icons.save,size:40,color: Constants.iconColor,),
            onPressed: () {
              this.gotImage = true;
              _selectImage(buildContext);
            },
          ),
        ]);
  }

  _close(BuildContext buildContext,bool gotImage){
    if(imagePath.length != 0) {
      File file = File(imagePath);
      if(file.existsSync()) {
        if(! gotImage) {
          file.deleteSync();
          print("Preview screen - deleted " + imagePath);
        }
      }
    }
    //Navigator.of(buildContext).pop();
  }

  _selectImage(BuildContext buildContext){

    SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
    bloc.sightingEventController.add(SightingImageChangeEvent(this._newFileName));
    Navigator.of(buildContext).pop();
    Navigator.of(buildContext).pop();

  }

}