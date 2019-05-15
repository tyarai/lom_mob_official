
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';

class UserSession {

  static Future<int> loadCurrentUserUID() async {

    String _strUID = await LOMSharedPreferences.loadString(User.uidKey);

    if(_strUID != null && _strUID.length > 0 ) return int.parse(_strUID);

    return 0;
  }
}