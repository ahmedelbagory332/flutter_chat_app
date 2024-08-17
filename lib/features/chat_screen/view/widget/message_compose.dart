import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/features/chat_screen/manager/chat_cubit.dart';
import '../../manager/chat_state.dart';

class MessagesCompose extends StatelessWidget {
   MessagesCompose({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocConsumer<ChatCubit, ChatState>(
          listener: (BuildContext context, state) {

          },
          builder: (BuildContext context, state) {
            return Row(
              children: [
                 SizedBox(
                        width: MediaQuery.of(context).size.width - 55,
                        child: Card(
                          color: const Color(0xff121212),
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              controller: _textController,
                               keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  context.read<ChatCubit>().updateUserStatus(
                                      "typing....",
                                      context
                                          .read<ChatCubit>()
                                          .getCurrentUser()!
                                          .uid);
                                  context
                                      .read<ChatCubit>()
                                      .sendChatButtonChanged(true);
                                } else {
                                  context.read<ChatCubit>().updateUserStatus(
                                      "Online",
                                      context
                                          .read<ChatCubit>()
                                          .getCurrentUser()!
                                          .uid);
                                  context
                                      .read<ChatCubit>()
                                      .sendChatButtonChanged(false);
                                }
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type your message",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                contentPadding: EdgeInsets.all(5),
                              )),
                        )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xff121212),
                    child: IconButton(
                        onPressed: () async {
                          if(_textController.text.toString().isEmpty) {
                            return;
                          }
                            context.read<ChatCubit>().sendMessage(
                                chatId: state.chatId,
                                senderId: context
                                    .read<ChatCubit>()
                                    .getCurrentUser()!
                                    .uid,
                                receiverId: context
                                    .read<ChatCubit>()
                                    .getPeerUserData()["userId"],
                                receiverUsername: context
                                    .read<ChatCubit>()
                                    .getPeerUserData()["name"],
                                msgTime: FieldValue.serverTimestamp(),
                                msgType: "text",
                                message: _textController.text.toString(),
                                fileName: "");


                            _textController.clear();

                            context
                                .read<ChatCubit>()
                                .sendChatButtonChanged(false);
                            context.read<ChatCubit>().updateUserStatus(
                                "Online",
                                context
                                    .read<ChatCubit>()
                                    .getCurrentUser()!
                                    .uid);
                        },
                        icon: const Icon(
                           Icons.send,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
