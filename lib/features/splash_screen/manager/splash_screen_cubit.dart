import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_application/features/splash_screen/manager/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit(this.user) : super(SplashScreenState.initial());
  final FirebaseAuth user;

  void initRoute() {
    Timer(const Duration(seconds: 2), () {
      if (user.currentUser != null) {
        emit(state.copyWith(status: SplashScreenStatus.home));
      } else {
        emit(state.copyWith(status: SplashScreenStatus.auth));
      }
    });
  }
}
