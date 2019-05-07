import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_global_values.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_edit_page.dart';


class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  // Add two variables to the state class to store the CameraController and
  // the Future
  CameraController _controller;
  Future<void> _initializeControllerFuture;

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

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure the camera is initialized
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the path
            // package.
            final path = join(
              // In this example, store the picture in the temp directory. Find
              // the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SightingGlobalValues(child:DisplayPictureScreen(imagePath: path)),
              ),
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
      body: ListView(children: <Widget>[Image.file(File(imagePath))]),
    );
  }

  Widget _buildAppBar(BuildContext context) {

    return AppBar(actions: <Widget>[
      IconButton(
        icon: Icon(Icons.cancel,size: 40,color: Colors.redAccent,),
        onPressed: () {

          // Delete the previous file name
          File file = File(imagePath);
          file.deleteSync();
          Navigator.pop(context);

        },
      ),
      Container(width:10),
      IconButton(
        icon: Icon(Icons.save,size:40,color: Colors.lightGreenAccent,),
        onPressed: () {
          _selectImage(context);
        },
      ),
    ]);
  }

  _selectImage(BuildContext context){

    var global = SightingGlobalValues.of(context);
    global.bloc.sightingEventSink.add(SightingImageChangeEvent(this.imagePath));

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return SightingGlobalValues(child:SightingEditPage(title: "New sighting",));
        }));

  }



}
