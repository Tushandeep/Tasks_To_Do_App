import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasktodo_app/model/todo.dart';

class TaskDatabase {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ToDo>> getPendingTasks({required String uid}) {
    try {
      return firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .where('done', isEqualTo: false)
        .where('expired', isEqualTo: false)
        .snapshots().map((tasks) {
          List<ToDo> items = [];
          for(final DocumentSnapshot task in tasks.docs) {
            items.add(ToDo.fromDocumentSnapshot(task));
          }
          return items;
        });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ToDo>> getCompletedTasks({required String uid}) {
    try {
      return firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .where('done', isEqualTo: true)
        .where('expired', isEqualTo: false)
        .snapshots().map((tasks) {
          List<ToDo> items = [];
          for(final DocumentSnapshot task in tasks.docs) {
            items.add(ToDo.fromDocumentSnapshot(task));
          }
          return items;
        });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ToDo>> getExpiredTasks({required String uid}) {
    try {
      return firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .where('done', isEqualTo: false)
        .where('expired', isEqualTo: true)
        .snapshots().map((tasks) {
          List<ToDo> items = [];
          for(final DocumentSnapshot task in tasks.docs) {
            items.add(ToDo.fromDocumentSnapshot(task));
          }
          return items;
        });
    } catch (e) {
      rethrow;
    }
  }


  Future<void> setTask({required String uid, required ToDo todo}) async {
    try {
      todo.taskId = todo.taskId = firestore.collection('TasksToDo').doc(uid).collection('todos').doc().id;
      firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .doc(todo.taskId)
        .set({
          'taskId': todo.taskId,
          'taskName': todo.taskName,
          'taskTime': todo.taskTime,
          'taskDate': todo.taskDate,
          'taskDesc': todo.taskDesc,
          'done': todo.done,
          'expired': todo.expired,
        });                                          
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsDoneTask({required String uid, required String taskId}) async {
    try {
      firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .doc(taskId)
        .update({
          'done': true,
        });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsUnDoneTask({required String uid, required String taskId}) async {
    try {
      firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .doc(taskId)
        .update({
          'done': false,
        });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setTaskExpired({required String uid, required String taskId}) async {
    try {
      firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .doc(taskId)
        .update({
          'expired': true,
        });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask({required String uid, required ToDo todo, required String taskId}) async {
    try { 
      firestore
        .collection('TasksToDo')
        .doc(uid)
        .collection('todos')
        .doc(taskId)
        .update({
          'taskId': taskId,
          'taskName': todo.taskName,
          'taskTime': todo.taskTime,
          'taskDate': todo.taskDate,
          'taskDesc': todo.taskDesc,
          'done': todo.done,
          'expired': todo.expired,
        });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(AsyncSnapshot<List<ToDo>> snapshot, int index, String uid) async {
    await firestore.collection('TasksToDo').doc(uid).collection('todos').doc(snapshot.data![index].taskId).delete();
  }
  
}