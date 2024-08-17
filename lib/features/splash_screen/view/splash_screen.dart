import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/features/splash_screen/manager/splash_screen_cubit.dart';
import 'package:chat_application/features/splash_screen/manager/splash_screen_state.dart';
import 'package:go_router/go_router.dart';
import '../../../core/app_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<SplashScreenCubit, SplashScreenState>(
        listener: (BuildContext context, state) {
          if (state.status == SplashScreenStatus.home) {
            GoRouter.of(context).go(AppRouter.kHomeView);
          } else if (state.status == SplashScreenStatus.auth) {
            GoRouter.of(context).go(AppRouter.kSignIn);

          }
        },
        child: Scaffold(
            body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/chat_icon.png'),
              const Text(
                'Real-Time Chat',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                    color: Colors.black87),
              ),
              const CircularProgressIndicator()
            ],
          ),
        )),
      ),
    );
  }
}
