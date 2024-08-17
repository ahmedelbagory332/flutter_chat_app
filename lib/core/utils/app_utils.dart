import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildShowSnackBar(
    BuildContext context, String msg) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      msg,
      style: const TextStyle(fontSize: 16),
    ),
  ));
}

List<Map<String, dynamic>> convertQuerySnapshotToList(
    QuerySnapshot<Map<String, dynamic>> snapshot) {
  return snapshot.docs.map((doc) => doc.data()).toList();
}

String mapListToString(List<Map<String, dynamic>> mapList) {
  for (var i = 0; i < mapList.length; i++) {
    var map = mapList[i];
    for (var key in map.keys) {
      var value = map[key];
      if (value is Timestamp) {
        // convert Timestamp to string representation
        map[key] = value.toDate().toString();
      }
    }
  }
  return json.encode(mapList);
}

List<Map<String, dynamic>> stringToMapList(String jsonString) {
  List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => Map<String, dynamic>.from(json)).toList();
}
