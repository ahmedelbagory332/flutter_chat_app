import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/failures.dart';
import 'chat_repo.dart';

class ChatRepoImpl implements ChatRepo {
  ChatRepoImpl(this.user);

  final FirebaseAuth user;

  @override
  Future<Either<Failure, bool>> updateUserStatus(userStatus, userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'userStatus': userStatus});
      return right(true);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required msgTime,
      required msgType,
      required message,
      required fileName}) async {
    try {
      await FirebaseFirestore.instance
          .collection("messages")
          .doc(chatId)
          .collection(chatId)
          .doc("${Timestamp.now().millisecondsSinceEpoch}")
          .set({
        'chatId': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'msgTime': msgTime,
        'msgType': msgType,
        'message': message,
        'fileName': fileName,
      });
      return right(true);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateLastMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required receiverUsername,
      required msgTime,
      required msgType,
      required message}) async {
    try {
      _lastMessageForPeerUser(receiverId, senderId, chatId, receiverUsername,
          msgTime, msgType, message);
      _lastMessageForCurrentUser(receiverId, senderId, chatId, receiverUsername,
          msgTime, msgType, message);
      return right(true);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  void _lastMessageForCurrentUser(receiverId, senderId, chatId,
      receiverUsername, msgTime, msgType, message) {
    FirebaseFirestore.instance
        .collection("lastMessages")
        .doc(senderId)
        .collection(senderId)
        .where('chatId', isEqualTo: chatId)
        .get()
        .then((QuerySnapshot value) {
      if (value.size == 0) {
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(senderId)
            .collection(senderId)
            .doc("${Timestamp.now().millisecondsSinceEpoch}")
            .set({
          'chatId': chatId,
          'messageFrom': user.currentUser!.displayName,
          'messageTo': receiverUsername,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime': msgTime,
          'msgType': msgType,
          'message': message,
        });
      } else {
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(senderId)
            .collection(senderId)
            .doc(value.docs[0].id)
            .update({
          'messageFrom': user.currentUser!.displayName,
          'messageTo': receiverUsername,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime': msgTime,
          'msgType': msgType,
          'message': message,
        });
      }
    });
  }

  void _lastMessageForPeerUser(receiverId, senderId, chatId, receiverUsername,
      msgTime, msgType, message) {
    FirebaseFirestore.instance
        .collection("lastMessages")
        .doc(receiverId)
        .collection(receiverId)
        .where('chatId', isEqualTo: chatId)
        .get()
        .then((QuerySnapshot value) {
      if (value.size == 0) {
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(receiverId)
            .collection(receiverId)
            .doc("${Timestamp.now().millisecondsSinceEpoch}")
            .set({
          'chatId': chatId,
          'messageFrom': user.currentUser!.displayName,
          'messageTo': receiverUsername,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime': msgTime,
          'msgType': msgType,
          'message': message,
        });
      } else {
        FirebaseFirestore.instance
            .collection("lastMessages")
            .doc(receiverId)
            .collection(receiverId)
            .doc(value.docs[0].id)
            .update({
          'messageFrom': user.currentUser!.displayName,
          'messageTo': receiverUsername,
          'messageSenderId': senderId,
          'messageReceiverId': receiverId,
          'msgTime': msgTime,
          'msgType': msgType,
          'message': message,
        });
      }
    });
  }

}
