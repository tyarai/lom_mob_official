import 'dart:async';
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

  @override
  void dispose() {
    print("SIGHTING BLOC : Close");
    _sightingEventController.close();
    _sightingController.close();
  }

  void _mapEventToState(SightingEvent event){


    if (event is SightingChangeEvent) {
      _sighting = event.sighting;
      print("...changed bloc's sighting to: ${_sighting.photoFileName}");
    }

    if (event is SightingImageChangeEvent) {
      _sighting.photoFileName = event.newFileName;
      print("...changed bloc's sighting image name to: ${_sighting.photoFileName}");
    }

    if (event is SightingSiteChangeEvent) {
      _sighting.site = event.site;
      print("...changed bloc's sighting site event to ${_sighting.site}");
    }

    if (event is SightingSpeciesChangeEvent) {
      _sighting.species = event.species;
      print("...changed bloc's sighting species to ${_sighting.species}" );
    }

    if (event is SightingLocationChangeEvent) {
      _sighting.longitude = event.longitude;
      _sighting.latitude  = event.latitude;
      _sighting.altitude  = event.altitude;
      print("...changed bloc's location to LONG: ${_sighting.longitude} LAT: ${_sighting.latitude}  ALT: ${_sighting.altitude}" );
    }

    //Add the new value of sighting to the sink state controller so that this can be returned
    //through the stream int the future
    _inSightingAdd.add(_sighting);
  }

}

