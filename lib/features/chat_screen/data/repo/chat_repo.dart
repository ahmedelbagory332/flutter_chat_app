import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';

abstract class ChatRepo {
  Future<Either<Failure, bool>> updateUserStatus(userStatus, userId);

  Future<Either<Failure, bool>> sendMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required msgTime,
      required msgType,
      required message,
      required fileName});

  Future<Either<Failure, bool>> updateLastMessage(
      {required chatId,
      required senderId,
      required receiverId,
      required receiverUsername,
      required msgTime,
      required msgType,
      required message});


}
