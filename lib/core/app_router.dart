import 'package:chat_application/core/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/chat_screen/chat_screen.dart';
import '../features/chat_screen/data/repo/chat_repo_impl.dart';
import '../features/chat_screen/manager/chat_cubit.dart';
import '../features/home_screen/data/repo/home_repo_impl.dart';
import '../features/home_screen/manager/homeCubit/home_cubit.dart';
import '../features/home_screen/view/home_screen.dart';
import '../features/sign_in/data/repo/sign_in_repo_impl.dart';
import '../features/sign_in/manager/sign_in_cubit.dart';
import '../features/sign_in/view/sign_in.dart';
import '../features/sign_up/data/repo/sign_up_repo_impl.dart';
import '../features/sign_up/manager/sign_up_cubit.dart';
import '../features/sign_up/view/sign_up.dart';
import '../features/splash_screen/manager/splash_screen_cubit.dart';
import '../features/splash_screen/view/splash_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static const kSplashView = '/';
  static const kSignUp = '/signUp';
  static const kSignIn = '/signIn';
  static const kHomeView = '/home';
  static const kChatScreen = '/chat';

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: kSplashView,
        builder: (context, state) {
          return BlocProvider(
              create: (context) => SplashScreenCubit(
                    getIt.get<FirebaseAuth>(),
                  )..initRoute(),
              child: const SplashScreen());
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: kSignUp,
        builder: (context, state) {
          return BlocProvider(
              create: (context) => SignUpCubit(
                    getIt.get<SignUpRepoImpl>(),
                    getIt.get<FirebaseAuth>(),
                  ),
              child: SignUp());
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: kSignIn,
        builder: (context, state) {
          return BlocProvider(
              create: (context) => SigInCubit(
                    getIt.get<SignInRepoImpl>(),
                    getIt.get<FirebaseAuth>(),
                  ),
              child: SignIn());
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: kHomeView,
        builder: (context, state) {
          return BlocProvider(
              create: (context) => HomeCubit(
                    getIt.get<HomeRepoImpl>(),
                    getIt.get<FirebaseAuth>(),
                  ),
              child: const HomeScreen());
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: kChatScreen,
        builder: (context, state) {
          return BlocProvider(
              create: (context) => ChatCubit(
                    getIt.get<ChatRepoImpl>(),
                    getIt.get<SharedPreferences>(),
                    getIt.get<FirebaseAuth>(),
                  )..getPeeredUserStatus(),
              child: const ChatScreen());
        },
      ),
    ],
  );
}
