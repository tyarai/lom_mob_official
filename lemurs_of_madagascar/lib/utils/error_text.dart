import 'package:lemurs_of_madagascar/utils/constants.dart';
class ErrorText {
  static String loginNameError = "Invalid login name!\nRequires at least ${Constants.minUsernameLength} characers";
  static String passwordError  = "No password provided!";
  static String emailError = "Invalid mail address!";
  static String credentialMessageError = "Wrong username or password!\nPlease check and try again";
  static String credentialTitleError = "Authentication error";
  static String registerTitleError = "Registration error";
  static String registerPasswordsDoNotMatch = "Passwords do not match!\nPlease check and try again";
  static String takenNameOrMail = "Username and/or email are already taken!\nPlease check and provide different ones";
}



