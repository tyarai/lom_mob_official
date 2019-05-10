import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';

abstract class SightingEvent{}


class SightingChangeEvent extends SightingEvent {
  Sighting sighting;
  SightingChangeEvent(this.sighting);
}

class SightingImageChangeEvent extends SightingEvent {
  String newFileName;
  SightingImageChangeEvent(this.newFileName);
}

class SightingSpeciesChangeEvent extends SightingEvent {
  Species species;
  SightingSpeciesChangeEvent(this.species);
}

class SightingSiteChangeEvent extends SightingEvent {
  Site site;
  SightingSiteChangeEvent(this.site);
}

class SightingTitleChangeEvent extends SightingEvent {
  String newTitle;
  SightingTitleChangeEvent(this.newTitle);
}

class SightingDateChangeEvent extends SightingEvent {
  DateTime newDate;
  SightingDateChangeEvent(this.newDate);
}

