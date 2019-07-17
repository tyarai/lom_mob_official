import 'package:lemurs_of_madagascar/utils/constants.dart';
class ErrorText {
  static String loginNameError = "Invalid login name!\nRequires at least ${Constants.minUsernameLength} characers";
  static String passwordError  = "No password provided!";
  static String emailError = "Invalid mail address!";
  static String credentialMessageError = "Wrong username or password!\nPlease check and try again";
  static String unauthorizedOperation = "Unauthorized operation!";
  static String anonymousUser = "Access denied for user anonymous!\nYou need to be logged in to interact with the server";

  static String credentialTitle = "Authentication";
  static String serviceTitle = "Service";
  static String serverTitle = "Server response";
  static String registerTitleError = "Registration error";
  static String registerPasswordsDoNotMatch = "Passwords do not match!\nPlease check and try again";
  static String takenNameOrMail = "Username and/or email are already taken!\nPlease check and provide different ones";

  static String unreachableAddress = "Unable to reach the server!\nPlease check your connection and try again";

  static String invalidIntegerNumber = "Invalid number!\n";
  static String noSpeciesError = "Please select a species!\n";
  static String noActivityTypeError = "Select a type of illegal activity!\n";
  static String noSiteError = "Please Select a site!\n";
  static String noSpeciesCount = "Please provide the number observed!\n";
  static String noTitle = "Please give a title to this sighting!\n";
  static String noImage = "No image of the illegal activity is selected!\n Please provide one or select a species to set a default image";
  static String emptyString = "No value provided!\n";
  static String disabledGPS = "Location service is disabled!\nTo capture location, please go to your phone settings and activate the service";

}



