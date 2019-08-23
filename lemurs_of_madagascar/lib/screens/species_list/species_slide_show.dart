import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:lemurs_of_madagascar/utils/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class SpeciesSlideShow extends StatefulWidget {
  final Species species;


  SpeciesSlideShow({this.species});

  @override
  State<StatefulWidget> createState() {
    return SpeciesSlideShowState(species: species);
  }
}

class SpeciesSlideShowState extends State<SpeciesSlideShow> {
  final Species species;
  //List<ExactAssetImage> _imageList = List();
  List<ImageProvider> _imageList = List();
  Carousel carousel;

  SpeciesSlideShowState({this.species}) {
    _loadImages();
    carousel = Carousel(
      animationDuration : Duration(milliseconds: 500),
      boxFit: BoxFit.contain,
      images: _imageList,
      dotSize: 6.0,
      dotSpacing: 15.0,
      dotColor: Constants.iconColor,
      indicatorBgPadding: 5.0,
      dotBgColor: Constants.mainColor,
      borderRadius: true,
      //moveIndicatorFromBottom: 180.0,
      noRadiusForIndicator: true,
    );
  }

  _loadImages() async {

    if (species != null) {
      String stringPhotoIDs = species.photoIDs;
      List<int> photoID = stringPhotoIDs.split(",").map((stringID) {
        return int.parse(stringID);
      }).toList();

      print("TABLE "+ photoID.toString());

      for (int i = 0; i < photoID.length; i++) {
        int id = photoID[i];
        PhotographDatabaseHelper photographDatabaseHelper =
            PhotographDatabaseHelper();
        Photograph photo =
            await photographDatabaseHelper.getPhotographWithID(id: id);

          if(photo != null) {

            String imageFile = photo.photograph ;
            if(! imageFile.endsWith(Constants.imageType)){
              imageFile = photo.photograph + "." + Constants.imageType;
            }

            //print("SLIDE "+imageFile);

            LOMImage.checkAssetFile(imageFile).then((exists){

              if(exists){

                String assetFile = Constants.appImagesAssetsFolder + imageFile;
                Image image = Image.asset(assetFile,);
                _imageList.add(image.image);

              }else{

                getApplicationDocumentsDirectory().then((docFolder){

                  if(docFolder != null) {
                    String fullPath = join(docFolder.path, imageFile);
                    File file = File(fullPath);
                    Image image = Image.file(file, fit: BoxFit.fitHeight,);
                    _imageList.add(image.image);
                  }

                });

              }


            });


             /*FutureBuilder<bool>(

                future : LOMImage.checkAssetFile(photo.photograph),
                builder : (context,snapshot)  {

                  if(snapshot.hasData) {

                    if(snapshot.data){

                      String assetFile = Constants.appImagesAssetsFolder + photo.photograph;
                      Image image = Image.asset(assetFile,);
                      _imageList.add(image);
                      return image;

                    }else{

                       return FutureBuilder<Directory>(

                          future : getApplicationDocumentsDirectory(),
                          builder : (context,snapshot)  {

                            if(snapshot.hasData && snapshot.data != null) {

                              String fullPath = join(snapshot.data.path, photo.photograph);
                              File file = File(fullPath);
                              Image image = Image.file(file, fit: BoxFit.fitHeight,);
                              _imageList.add(image);
                              return image;

                            }

                            return null;



                          });

                    }
                  }

                  return null;

                }

            ); */
          }
      }
    }

    setState(() {});
  }

  Widget _buildCarousel(BuildContext context,{int xOffset = 50, int yOffset = 80}) {
    //await _loadImageFilenames();
    Widget widget;

    try {
      widget = _imageList.length == 0
          ? Center(
              child: Container(
              child: CircularProgressIndicator(),
            ))
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:carousel,
            );
    } catch (e) {}

    return widget;
  }

  @override
  Widget build(BuildContext context) {
    Widget futureWidget = Scaffold(
        backgroundColor: Constants.mainColor,
        body: SafeArea(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 20,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [OutlineButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Constants.iconColor,
                        size: 35,
                      ),
                      label: Text(""))]
              ),

              /*Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children:<Widget>[ OutlineButton.icon(
                      onPressed: () {
                      //@TODO : Add share fonctionnality to share image to social app
                        _shareCurrentImage();
                      },
                      icon: Icon(
                        Icons.share,
                        color: Constants.iconColor,
                        size: 35,
                      ),
                      label: Text(""))]
              ),*/

            ]),
            Expanded(child: _buildCarousel(context)),
          ],
        )));

    return futureWidget;
  }


}
