import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/features/home_screen/view/widget/recent_chats.dart';
import 'package:chat_application/features/home_screen/view/widget/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_router.dart';
import '../../../core/service_locator.dart';
import '../data/repo/home_repo_impl.dart';
import '../manager/homeCubit/home_cubit.dart';
import '../manager/lastMessagesCubit/last_message_cubit.dart';
import '../manager/usersCubit/users_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff121212),
          title: const Text("All Users",style: TextStyle(color: Colors.white),),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  context.read<HomeCubit>().signOut();
                  GoRouter.of(context).go(AppRouter.kSignIn);
                },
                icon: const Icon(Icons.logout_sharp,color: Colors.white))
          ],
        ),
        body: Container(
          color: const Color(0xff121212).withOpacity(.9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider(
                create: (context) => UsersCubit(
                  getIt.get<HomeRepoImpl>(),
                  getIt.get<SharedPreferences>(),
                  getIt.get<FirebaseAuth>(),
                )..getUsers(),
                child: const Users(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Recent Chats',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.white
                      // color: AppColors.textFaded,
                      ),
                ),
              ),
              BlocProvider(
                create: (context) =>LastMessagesCubit(
                  getIt.get<HomeRepoImpl>(),
                  getIt.get<SharedPreferences>(),
                  getIt.get<FirebaseAuth>(),
                )..getLastMessages(),
                child: const RecentChats(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
