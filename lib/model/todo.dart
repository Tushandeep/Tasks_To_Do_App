import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {

  String taskId = "";
  late String taskName;
  late String taskTime;
  late String taskDate;
  late String taskDesc;
  late bool done;
  late bool expired;

  ToDo({required this.taskName, required this.taskDate, required this.taskTime, required this.taskDesc, required this.done, required this.expired,});

  ToDo.fromDocumentSnapshot(DocumentSnapshot docSnap) {
    taskId = docSnap.get('taskId');
    taskName = docSnap.get('taskName');
    taskDate = docSnap.get('taskDate');
    taskTime = docSnap.get('taskTime');
    taskDesc = docSnap.get('taskDesc');
    done = docSnap.get('done');
    expired = docSnap.get('expired');
  }

}