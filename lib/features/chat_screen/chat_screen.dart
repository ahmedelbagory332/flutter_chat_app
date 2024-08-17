import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/features/chat_screen/view/widget/message_compose.dart';
import 'package:chat_application/features/chat_screen/view/widget/sub_title_app_bar.dart';

import 'manager/chat_cubit.dart';
import 'view/widget/messages_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late ChatCubit _appProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<ChatCubit>().updateUserStatus(
        "Online", context.read<ChatCubit>().getCurrentUser()!.uid);

    context.read<ChatCubit>().peerUserChanged();

    context.read<ChatCubit>().getMessages();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appProvider = BlocProvider.of<ChatCubit>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appProvider.updateUserStatus(
        FieldValue.serverTimestamp(), _appProvider.getCurrentUser()!.uid);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        context.read<ChatCubit>().updateUserStatus(FieldValue.serverTimestamp(),
            context.read<ChatCubit>().getCurrentUser()!.uid);
        break;
      case AppLifecycleState.inactive:
        context.read<ChatCubit>().updateUserStatus(FieldValue.serverTimestamp(),
            context.read<ChatCubit>().getCurrentUser()!.uid);
        break;
      case AppLifecycleState.detached:
        context.read<ChatCubit>().updateUserStatus(FieldValue.serverTimestamp(),
            context.read<ChatCubit>().getCurrentUser()!.uid);
        break;
      case AppLifecycleState.resumed:
        context.read<ChatCubit>().updateUserStatus(
            "Online", context.read<ChatCubit>().getCurrentUser()!.uid);
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff121212),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white),
            onPressed: () {
                Navigator.of(context).pop();
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.read<ChatCubit>().getPeerUserData()["name"],
                  style: const TextStyle(
                      fontSize: 18.5, fontWeight: FontWeight.bold,color: Colors.white)),
              const SubTitleAppBar(),
            ],
          ),

        ),
        body: Container(
          color: const Color(0xff121212).withOpacity(.9),
          child:  Column(
            children: [
              const Expanded(
                child: Messages(),
              ),
              MessagesCompose(),
            ],
          ),
        ));
  }
}
