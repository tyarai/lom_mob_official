import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/tag.dart';

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

class SightingTagChangeEvent extends SightingEvent {
  Tag tag;
  SightingTagChangeEvent(this.tag);
}

class SightingSiteChangeEvent extends SightingEvent {
  Site site;
  SightingSiteChangeEvent(this.site);
}

class SightingTitleChangeEvent extends SightingEvent {
  String newTitle;
  SightingTitleChangeEvent(this.newTitle);
}

class SightingNumberObservedChangeEvent extends SightingEvent {
  int newNumber;
  SightingNumberObservedChangeEvent(this.newNumber);
}


class SightingDateChangeEvent extends SightingEvent {
  double newDate;
  SightingDateChangeEvent(this.newDate);
}

class SightingLocationChangeEvent extends SightingEvent {
  double longitude = 0.0;
  double latitude = 0.0;
  double altitude = 0.0;

  SightingLocationChangeEvent({this.longitude,this.latitude,this.altitude});
}

