import 'dart:async';
import 'dart:io';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';

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


  void saveSighting(){
    //print("Saving this sighting " + _sighting.toString());
    _sighting.saveToDatabase();
  }

  void _deleteOldPhotoFile(){

    if(_sighting.photoFileName != null && _sighting.photoFileName.length > 0){

        File file = File(_sighting.photoFileName);
        if(file.existsSync()) {
          file.deleteSync();
          print("Bloc Event Image Changed - deleted old file " +
              _sighting.photoFileName);
        }else{
          print("Bloc Event Image Changed - no file to delete at " +
              _sighting.photoFileName);
        }

      }
  }

  @override
  void dispose() {
    //print(.*)
    _sightingEventController.close();
    _sightingController.close();
  }

  void _mapEventToState(SightingEvent event){


    if (event is SightingChangeEvent) {
      _sighting = event.sighting;
      //print(.*)
    }

    if (event is SightingImageChangeEvent) {
      _deleteOldPhotoFile();
      _sighting.photoFileName = event.newFileName;
      //print(.*)
    }

    if (event is SightingSiteChangeEvent) {
      _sighting.site = event.site;
      _sighting.placeName = event.site.title;
      //print(.*)
    }

    if (event is SightingSpeciesChangeEvent) {
      _sighting.species = event.species;
      _sighting.speciesName = event.species.title;
      //print("new title ${_sighting.species.title}");
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

