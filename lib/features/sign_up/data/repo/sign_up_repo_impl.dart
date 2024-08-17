import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/failures.dart';
import 'sign_up_repo.dart';

class SignUpRepoImpl implements SignUpRepo {
  final FirebaseAuth user;

  SignUpRepoImpl(this.user);

  @override
  Future<Either<Failure, UserCredential>> signUp(
      {required String email,
      required String name,
      required String password}) async {
    try {
      var createUser = await user.createUserWithEmailAndPassword(
          email: email, password: password);
      createUser.user!.updateDisplayName(name.trim().toString());
      addNewUser(createUser.user!.uid, name, email, "Online", "");
      return right(createUser);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return left(ServerFailure.fromFireBase(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  void addNewUser(userId, name, email, userStatus, chatWith) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'userId': userId,
      'userStatus': userStatus,
      'chatWith': chatWith,
    });
  }


}
