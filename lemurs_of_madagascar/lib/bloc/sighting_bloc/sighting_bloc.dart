import 'dart:async';
import 'dart:io';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SightingBloc implements BlocBase {

  Sighting _sighting;

  StreamController<Sighting> _sightingController = StreamController<Sighting>.broadcast();
  Sink<Sighting> get _inSightingAdd => _sightingController.sink;
  Stream<Sighting> get outSighting => _sightingController.stream;


  StreamController<SightingEvent> _sightingEventController = StreamController<SightingEvent>();
  Sink<SightingEvent> get sightingEventController => _sightingEventController.sink;


  SightingBloc()  {
    _sightingEventController.stream.listen(_mapEventToState);
  }


  /*Future<bool> saveSighting(bool editing) async {
    return _sighting.saveToDatabase(editing).then((saved){
      return saved;
    });

  }*/

  Sighting get sighting => this._sighting;

  Future<bool> _deleteOldPhotoFile(){

    return getApplicationDocumentsDirectory().then((_folder) {

      if (_folder != null) {

        String fullPath = join(_folder.path, _sighting.photoFileName);

        File file = File(fullPath);

        if (file.existsSync()) {
          file.deleteSync();
          print("[SIGHTING_BLOC::_deleteOldPhotoFile()] deleted old file " + fullPath);
          return true;
        } else {
          print(
              "[SIGHTING_BLOC::_deleteOldPhotoFile()] no file to delete at " + fullPath);
          return false;
        }


      }

      return false;

    });

  }

  @override
  void dispose() {
    //print(.*)
    _sightingEventController.close();
    _sightingController.close();
  }

  void _mapEventToState(SightingEvent event){


    if (event is SightingChangeEvent) {
      _sighting = Sighting.withSighting(event.sighting);
      //print("Bloc sighting change  "+ _sighting.toString());
    }

    if (event is SightingImageChangeEvent) {

      _deleteOldPhotoFile().then((_){
        _sighting.photoFileName = event.newFileName;
        print("[BLOC PHOTOFILENAME ==>] "+ _sighting.photoFileName );
      });

    }

    if (event is SightingSiteChangeEvent) {
      _sighting.site = event.site;
      _sighting.placeName = event.site.title;
      _sighting.placeNID = event.site.id;
      //print(.*)
    }

    if (event is SightingSpeciesChangeEvent) {
      _sighting.species = event.species;
      _sighting.speciesName = event.species.title;
      _sighting.speciesNid = event.species.id;
      //print("new species ${_sighting.species.title}");
    }

    if (event is SightingDateChangeEvent) {
      _sighting.date = event.newDate;
      //print(.*)
    }

    if (event is SightingTitleChangeEvent) {
      _sighting.title = event.newTitle;

    }
    if (event is SightingNumberObservedChangeEvent) {
      _sighting.speciesCount = event.newNumber;
      //print(.*)
    }

    if (event is SightingLocationChangeEvent) {
      _sighting.longitude = event.longitude;
      _sighting.latitude  = event.latitude;
      _sighting.altitude  = event.altitude;
      //print(.*)
    }

    //Add the new value of sighting to the sink state controller so that this can be returned
    //through the stream int the future
    _inSightingAdd.add(_sighting);

    //print(_sighting.toString());
  }

}

