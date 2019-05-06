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

  SightingBloc() {
    // Map input event to output state
    _sightingEventController.stream.listen(_mapEventToState);
  }


  void _mapEventToState(SightingEvent event){

      if (event is SightingImageEvent) {
        print("Sighting Image Event");
        _sighting.photoFileName = event.newFileName;
      }

      if (event is SightingSiteEvent) {
        print("Sighting Site Event");
      }

      if (event is SightingSpeciesEvent) {
        print("Sighting Species Event");
      }

      _inSighting.add(_sighting);
  }

  void dispose() {
    _sightingStateController.close();
    _sightingEventController.close();
  }

}