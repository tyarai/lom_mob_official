abstract class SightingEvent{}

class SightingImageEvent extends SightingEvent {
  String newFileName;
  SightingImageEvent(this.newFileName);
}

class SightingSpeciesEvent extends SightingEvent {}

class SightingSiteEvent extends SightingEvent {}

