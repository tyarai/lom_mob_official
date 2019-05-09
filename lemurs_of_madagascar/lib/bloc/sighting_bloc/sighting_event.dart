import 'package:lemurs_of_madagascar/models/sighting.dart';

abstract class SightingEvent{}


class SightingChangeEvent extends SightingEvent {
  Sighting sighting;
  SightingChangeEvent(this.sighting);
}

class SightingImageChangeEvent extends SightingEvent {
  String newFileName;
  SightingImageChangeEvent(this.newFileName);
}

class SightingSpeciesChangeEvent extends SightingEvent {}

class SightingSiteChangeEvent extends SightingEvent {}

class SightingTitleChangeEvent extends SightingEvent {
  String newTitle;
  SightingTitleChangeEvent(this.newTitle);
}

class SightingDateChangeEvent extends SightingEvent {
  DateTime newDate;
  SightingDateChangeEvent(this.newDate);
}

