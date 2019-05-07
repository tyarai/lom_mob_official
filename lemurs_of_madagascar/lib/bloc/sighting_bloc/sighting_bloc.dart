import 'dart:async';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_event.dart';

class SightingBloc {

  Sighting _sighting = Sighting();


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
        print("Sighting Image Event");
        _sighting.photoFileName = event.newFileName;
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