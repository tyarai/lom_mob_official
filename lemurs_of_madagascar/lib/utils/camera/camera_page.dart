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

    // Next, you need to initialize the controller. This returns a Future
    _initializeControllerFuture = _controller.initialize();
  }

  _close(){

    if(path.length != 0) {
      File file = File(path);
      if(file.existsSync()) {
        file.deleteSync();
        print("DELETED " + path  );
      }

    }
  }

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    _controller.dispose();
    print("DSIPOSED Camera Controlle ");
    _close();
    super.dispose();
  }

  pickImageFromGallery(ImageSource source) {
    imageFile =  ImagePicker.pickImage(source: source);
  }

  handleImage(BuildContext context) {


    pickImageFromGallery(ImageSource.gallery);

    imageFile.then((file){

      if(file != null) {

        final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);



        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) =>
                BlocProvider(
                    bloc: bloc,
                    child: DisplayPictureScreen(imagePath: file.path))),
        );
      }

    });

    /*FutureBuilder<File>(

      future: null,//pickImageFromGallery(ImageSource.gallery),
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {

        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {


          print("FILE:"+snapshot.data.path);

          final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) =>
                  BlocProvider(
                      bloc: bloc,
                      child: DisplayPictureScreen(imagePath: snapshot.data.path))),
          );



        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );*/
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

    return Scaffold(

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
              path = join(
                // In this example, store the picture in the temp directory. Find
                // the temp directory using the `path_provider` plugin.
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              // Attempt to take a picture and log where it's been saved
              await _controller.takePicture(path);

              final SightingBloc bloc = BlocProvider.of<SightingBloc>(context);

              // If the picture was taken, display it on a new screen

              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) =>
                      BlocProvider(
                          bloc: bloc,
                          child: DisplayPictureScreen(imagePath: path))),
              );

            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
        ),

    );
  } // Fill this out in the next steps

}

// A Widget that displays the picture taken by the user
class DisplayPictureScreen extends StatelessWidget {

  final String imagePath;


  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
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
    );
  }

  Widget _buildAppBar(BuildContext buildContext) {

    return AppBar(
        title: Text("Preview",style:Constants.appBarTitleStyle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt,size: 40,color: Constants.iconColor,),
            onPressed: () {

              // Delete the previous file name and go back to camera
              _close(buildContext);

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

  _close(BuildContext buildContext){
    if(imagePath.length != 0) {
      File file = File(imagePath);
      if(file.existsSync()) {
        file.deleteSync();
        print("DELETED " + imagePath  );
      }
    }
    Navigator.of(buildContext).pop();
  }


  _selectImage(BuildContext buildContext){


    SightingBloc bloc = BlocProvider.of<SightingBloc>(buildContext);
    bloc.sightingEventController.add(SightingImageChangeEvent(this.imagePath));
    Navigator.of(buildContext).pop();
    Navigator.of(buildContext).pop();

  }



}
