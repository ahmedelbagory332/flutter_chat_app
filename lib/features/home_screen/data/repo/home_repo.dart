import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/utils/failures.dart';

abstract class HomeRepo {


  Stream<Either<Failure, QuerySnapshot<Map<String, dynamic>>>> getAllUsers();

  Stream<Either<Failure, QuerySnapshot<Map<String, dynamic>>>>
      getLastMessages();
}
