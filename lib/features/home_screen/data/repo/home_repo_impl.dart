import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/failures.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this.user);
  final FirebaseAuth user;



  @override
  Stream<Either<Failure, QuerySnapshot<Map<String, dynamic>>>>
      getAllUsers() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((users) => right(users));
    } catch (e) {
      yield left(ServerFailure("An error occurred: ${e.toString()}"));
    }
  }

  @override
  Stream<Either<Failure, QuerySnapshot<Map<String, dynamic>>>>
      getLastMessages() async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('lastMessages')
          .doc(user.currentUser!.uid)
          .collection(user.currentUser!.uid)
          .orderBy("msgTime", descending: true)
          .snapshots()
          .map((messages) => right(messages));
    } catch (e) {
      yield left(ServerFailure("An error occurred: ${e.toString()}"));
    }
  }
}
