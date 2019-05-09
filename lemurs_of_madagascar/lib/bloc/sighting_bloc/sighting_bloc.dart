import 'dart:async';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';

class SightingBloc implements BlocBase {

  Sighting _sighting;

  StreamController<Sighting> _sightingController = StreamController<Sighting>();
  Sink<Sighting> get _inSightingAdd => _sightingController.sink;
  Stream<Sighting> get outSighting => _sightingController.stream;


  StreamController<SightingEvent> _sightingEventController = StreamController<SightingEvent>();
  Sink<SightingEvent> get sightingEventController => _sightingEventController.sink;


  SightingBloc(){
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
      print("...changed bloc's sighting to: ${_sighting.title}");
    }

    if (event is SightingImageChangeEvent) {
      _sighting.photoFileName = event.newFileName;
      print("...changed bloc's sighting image name to: ${_sighting.photoFileName}");
    }

    if (event is SightingSiteChangeEvent) {
      print("...changed bloc's sighting site event to");
    }

    if (event is SightingSpeciesChangeEvent) {
      print("...changed bloc's sighting species to");
    }
    //Add the new value of sighting to the sink state controller so that this can be returned
    //through the stream int the future
    _inSightingAdd.add(_sighting);
  }

}


/*
class SightingBloc {

  Sighting _sighting = Sighting(photoFileName: "FROM_SIGHTING_BLOC.jpg");


  final _sightingStateController = StreamController<Sighting>();
  StreamSink<Sighting> get _inSighting => _sightingStateController.sink; // INPUT <=> SINK
  Stream<Sighting> get sighting => _sightingStateController.stream; // OUTPUT <=> STREAM


  final _sightingEventController = StreamController<SightingEvent>();
  // UI will input event into this sink
  Sink<SightingEvent> get sightingEventSink => _sightingEventController.sink;

  // NOTE: In this class the UI will only be exposed to two public properties which are
  //  1- Stream<Sighting> get sighting => _sightingStateController.stream;  (to return state)
  //  2- Sink<SightingEvent> get sightingEventSink => _sightingEventController.sink; (to input event)

  SightingBloc() {
    // Map input event to output state
    _sightingEventController.stream.listen(_mapEventToState);
  }


  void _mapEventToState(SightingEvent event){

      if (event is SightingImageChangeEvent) {
        _sighting.photoFileName = event.newFileName;
        print("Sighting Image Event  ${_sighting.photoFileName}");
      }

      if (event is SightingSiteChangeEvent) {
        print("Sighting Site Event");
      }

      if (event is SightingSpeciesChangeEvent) {
        print("Sighting Species Event");
      }
      //Add the new value of sighting to the sink state controller so that this can be returned
      //through the stream int the future
      _inSighting.add(_sighting);
  }

  void dispose() {
    _sightingStateController.close();
    _sightingEventController.close();
  }

}
*/