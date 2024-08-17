import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/chat_screen/data/repo/chat_repo_impl.dart';
import '../features/home_screen/data/repo/home_repo_impl.dart';
import '../features/sign_in/data/repo/sign_in_repo_impl.dart';
import '../features/sign_up/data/repo/sign_up_repo_impl.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _initSharedPref();


  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => SignUpRepoImpl(getIt.get<FirebaseAuth>(),));

  getIt.registerLazySingleton(() => SignInRepoImpl(getIt.get<FirebaseAuth>()));

  getIt.registerLazySingleton(() => HomeRepoImpl(
        getIt.get<FirebaseAuth>(),
      ));

  getIt.registerLazySingleton(() => ChatRepoImpl(
        getIt.get<FirebaseAuth>(),
      ));
}

Future<void> _initSharedPref() async {
  final SharedPreferences sharedPref = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPref);
}
