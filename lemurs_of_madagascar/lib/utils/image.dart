import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;


class LOMImage {

  static Future<bool> downloadHttpImage(String imageURL) async {

    //bool downloaded =false;

    if (imageURL != null && imageURL.startsWith(Constants.http)){

      print("File to download "+imageURL);

      var docFolder = await getApplicationDocumentsDirectory();
      Uri imageURI = Uri.parse(imageURL);
      List<String> pathSegments = imageURI.pathSegments;
      String fileName = pathSegments[pathSegments.length - 1];

      HttpClient client = new HttpClient();
      var _downloadData = List<int>();
      var fileSave = new File(docFolder.path + "/" + fileName);

      client.getUrl(imageURI).then((HttpClientRequest request) {
        print("#1");
        return request.close();


      }).then((HttpClientResponse response) {
          //
          response.listen((d) => _downloadData.addAll(d),
          onDone: () {
            fileSave.writeAsBytes(_downloadData);
            print("File saved to "+fileSave.path);
            print("[Image::_downloadHttpImage()] Success downloading image : $fileName");
            print("#2");
            return true;

            }
          );

          //return downloaded;

      }).catchError((error){
        print("[Image::_downloadHttpImage()] Failure - downloading image : $fileName");
        return false;
      });

      return true;
    }

    return false;

  }

  /*
  * fileName : does not include the URI part. Only the fileName is considered
  * */
  static Future<bool> doesFileExistInDocumentsFolder(String fileName) async {

    if(fileName.length != 0 && fileName != null) {

      return getApplicationDocumentsDirectory().then((_folder) {

        if (_folder != null) {

          String fullPath = join(_folder.path, fileName);

          File file = File(fullPath);

          if (file.existsSync()) {
            return true;
          }
        }

        return false;

      });
    }

    return false;

  }

  /*static Future<Image> getImage(String imageURL) async {

    if(imageURL != null && imageURL.startsWith(Constants.http)){

      Uri imageURI = Uri.parse(imageURL);
      List<String> pathSegments = imageURI.pathSegments;
      String fileName = pathSegments[pathSegments.length - 1];

      return LOMImage.downloadHttpImage(imageURL).then((downloaded)  {

        if(downloaded){

          //return LOMImage.doesFileExistInDocumentsFolder(fileName).then((exist){
            //if(exist) {
              return getApplicationDocumentsDirectory().then((docFolder) {
                String fullPath = join(docFolder.path, fileName);
                File file = File(fullPath);
                return Image.file(file);
              });
            //}
            //return null;
          //});

        }
        return null;

      });

    }

    if(imageURL != null && imageURL.startsWith(Constants.appImagesAssetsFolder)){
      return Image.asset(
        imageURL,
        width: Constants.authorListViewImageWidth,
        height: Constants.authorListViewImageWidth,
      );
    }

    return null;

  }*/


  static Future<Widget> getWidget(String fileName,{double width = Constants.listViewImageWidth,
    double height = Constants.listViewImageWidth}) async {

    if(fileName != null) {

      return LOMImage.checkAssetFile(fileName).then((exists){

        if(exists){

          //print("$fileName is in asset ");

          String image = fileName;

          if(! fileName.startsWith(Constants.appImagesAssetsFolder)){
            image = Constants.appImagesAssetsFolder + fileName;
          }


          //String image = Constants.appImagesAssetsFolder + fileName;


          return Container(
            child: Image.asset(
              image,
              fit:BoxFit.fitHeight,
              width: width,
              height: height,
            ),
          );

        }else{

          print("$fileName is not in asset");

          return doesFileExistInDocumentsFolder(fileName).then((exists){

            if (exists){

              print("$fileName is in document");

              return getApplicationDocumentsDirectory().then((_folder) {
                
                  if (_folder != null) {

                    String fullPath = join(_folder.path, fileName);

                    File file = File(fullPath);

                    if (file.existsSync()) {
                      return Container(
                        child: Image.file(file,fit:BoxFit.fitHeight,
                          width: width,
                          height: height,),
                      );
                    }
                  }
                  return Container();
                }
              );


            }else{

              String image = Constants.serverFileFolder + fileName;

              print("Downloading image "+image);

              return FutureBuilder(
                  future : downloadHttpImage(image),
                  builder : (context,snapshot)  {

                    if(snapshot.hasData &&  snapshot.data){
                      getApplicationDocumentsDirectory().then((docFolder){

                        String fullPath = join(docFolder.path, fileName);
                        //print("DOWNLOADED IMAGE "+fullPath);
                        File file = File(fullPath);

                        return  Container(
                          child: Image.file(file,fit:BoxFit.fitHeight,
                              width: width,
                              height: height,),
                        );

                      });
                    }
                    return Center(child:CircularProgressIndicator());

                  }

              );

            }

            return  Container();


          });




        }


      });
    }
    return null;

  }


  static Future<bool> checkAssetFile(String fileName) async {
    if(fileName != null && fileName.length != 0) {
      try {

        //print("FILENAME "+fileName);

        String assetName = fileName;

        if(! fileName.startsWith(Constants.appImagesAssetsFolder)){
           assetName = Constants.appImagesAssetsFolder + fileName;
        }

        //print("ASSET "+assetName);

        //String assetName = Constants.appImagesAssetsFolder + fileName;
        var data = await rootBundle.load(assetName);
        if (data != null) {
          return true;
        }
      } catch (e) {
        print("[LOMImage::checkAssetFile()] Exception : " + e.toString());
        return false;
      }
    }
    return false;
  }



}