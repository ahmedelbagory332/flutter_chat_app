import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_application/core/utils/app_utils.dart';
import 'package:chat_application/core/utils/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repo/chat_repo.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.chatRepo, this.sharedPreferences, this.user)
      : super(ChatState.initial());

  final ChatRepo chatRepo;
  final FirebaseAuth user;
  final SharedPreferences sharedPreferences;


  void sendChatButtonChanged(bool value) {
    emit(state.copyWith(sendChatButton: value));
  }


  void peerUserChanged() {
    getChatId(getPeerUserData()["userId"]);
    debugPrint("begoa state.peeredUser ${getPeerUserData()["userId"]}");
  }



  User? getCurrentUser() {
    return user.currentUser;
  }

  Map<String, dynamic> getPeerUserData() {
    return stringToMapList(sharedPreferences.getString("peerUserData")!)[0];
  }

  void updateUserStatus(userStatus, userId) async {
    var result = await chatRepo.updateUserStatus(userStatus, userId);
    result.fold((failure) {
      debugPrint("updateUserStatus ${failure.errMessage}");
    }, (success) {
      debugPrint("updateUserStatus ${success.toString()}");
    });
  }



  void getChatId(peerUserId) {
    emit(state.copyWith(
        chatId: user.currentUser!.uid.hashCode <= peerUserId.hashCode
            ? "${user.currentUser!.uid} - $peerUserId"
            : "$peerUserId - ${user.currentUser!.uid}"));
    debugPrint("begoa chat id ${state.chatId}");
  }

  Future<void> sendMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required receiverUsername,
      required msgTime,
      required msgType,
      required message,
      required fileName}) async {
    var result = await chatRepo.sendMessage(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        msgTime: msgTime,
        msgType: msgType,
        message: message,
        fileName: fileName);
    result.fold((failure) {
      debugPrint("bego sendMessage failure: ${failure.errMessage}");
    }, (success) async {
      debugPrint("bego sendMessage success: $success");
      //updateLastMessage
      var result = await chatRepo.updateLastMessage(
          chatId: chatId,
          senderId: senderId,
          receiverId: receiverId,
          receiverUsername: receiverUsername,
          msgTime: msgTime,
          msgType: msgType,
          message: message);
      result.fold((failure) {
        debugPrint("bego updateLastMessage failure: ${failure.errMessage}");
      }, (success) {
        debugPrint("bego updateLastMessage success: $success");
        // //getMessages
        // getMessages();
      });
    });
  }


  getPeeredUserStatus() {
    try {
      emit(state.copyWith(status: ChatStatus.gettingPeeredUser));

      FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: getPeerUserData()["userId"])
          .snapshots()
          .listen((event) {
        emit(state.copyWith(
            status: ChatStatus.peeredUser, peeredUser: event.docs[0]));
      });
    } catch (e) {
      debugPrint("ChatStatus.peeredUserError ${e.toString()}");

      emit(state.copyWith(
          failure: ServerFailure("An error occurred: ${e.toString()}"),
          status: ChatStatus.peeredUserError));
    }
  }

  void getMessages() {
    try {
      emit(state.copyWith(status: ChatStatus.gettingMessages));
      FirebaseFirestore.instance
          .collection('messages')
          .doc(state.chatId)
          .collection(state.chatId)
          .orderBy("msgTime", descending: true)
          .snapshots()
          .listen((event) {
        List<Map<String, dynamic>> list = [];
        for (var element in event.docs) {
          list.add(element.data());
        }
        emit(state.copyWith(status: ChatStatus.getMessages, messages: list));
      });
    } catch (error) {
      emit(state.copyWith(
          failure: ServerFailure("An error occurred: ${error.toString()}"),
          status: ChatStatus.getMessagesError));
    }
  }

}
