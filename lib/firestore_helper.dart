import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'worker.dart';

final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final CollectionReference workersCollectionReference = firebaseFirestore.collection('workers');

class FireStoreHelper {

  static Stream<QuerySnapshot> getWorkers() {
    return workersCollectionReference.snapshots();
  }

  static Future<void> addWorker({
    @required Worker worker,
  }) async {
    DocumentReference documentReference =
    workersCollectionReference.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": worker.workerName,
      "salary": worker.workerSalary,
      "age": worker.workerAge,
    };

    await documentReference
        .set(data)
        .whenComplete(() => print("Worker added to the firestore"))
        .catchError((e) => print(e));
  }

  static Future<void> updateWorker({
    @required Worker worker,
  }) async {
    DocumentReference documentReference =
    workersCollectionReference.doc(worker.workerId);

    Map<String, dynamic> data = <String, dynamic>{
      "name": worker.workerName,
      "salary": worker.workerSalary,
      "age": worker.workerAge,
    };

    await documentReference
        .update(data)
        .whenComplete(() => print("Worker updated in the firestore"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteWorker({
    @required String workerId,
  }) async {
    DocumentReference documentReferencer =
    workersCollectionReference.doc(workerId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Worker deleted from the firestore'))
        .catchError((e) => print(e));
  }

}