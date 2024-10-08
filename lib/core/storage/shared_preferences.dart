import 'package:shared_preferences/shared_preferences.dart';

import '../service_locator.dart';

setId(peerUserId) async {
  getIt.get<SharedPreferences>().setString("id", peerUserId);
}

setEmail(peeredEmail) async {
  getIt.get<SharedPreferences>().setString("email", peeredEmail);
}

setName(peeredName) async {
  getIt.get<SharedPreferences>().setString("name", peeredName);
}

String getId() {
  return getIt.get<SharedPreferences>().getString("id")!;
}

String getEmail() {
  return getIt.get<SharedPreferences>().getString("email")!;
}

String getName() {
  return getIt.get<SharedPreferences>().getString("name")!;
}

