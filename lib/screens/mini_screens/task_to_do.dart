import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/todo.dart';
import 'package:tasktodo_app/screens/new_task.dart';
import 'package:tasktodo_app/services/firebase_database.dart';
import 'package:tasktodo_app/services/theme_provider.dart';
import 'package:tasktodo_app/widgets/circle_loading.dart';
import 'package:tasktodo_app/widgets/todo_tile.dart';

class TaskToDo extends StatefulWidget {
  const TaskToDo({ Key? key }) : super(key: key);

  @override
  _TaskToDoState createState() => _TaskToDoState();
}

class _TaskToDoState extends State<TaskToDo> {

  List<ToDo> _items = [];

  void checkForExpiredTask() async {
    DateTime dateTime = DateTime.now();
    final currentHour = dateTime.hour;
    final currentMinute = dateTime.minute;
    final currentDay = dateTime.day;
    final currentMonth = dateTime.month;
    final currentYear = dateTime.year;

    for(int i=0;i < _items.length;i++) {
      final dates = _items[i].taskDate.split('-');
      final taskDateDay = int.parse(dates[0]);
      final taskDateMonth = int.parse(dates[1]);
      final taskDateYear = int.parse(dates[2]);
      final taskTime = _items[i].taskTime;
      final getHour = taskTime.split(':');
      final getMinute = getHour[1].split(' ');
      int taskTimeHour = int.parse(getHour[0]);
      final int taskTimeMinute = int.parse(getMinute[0]);
      final String taskPeriod = getMinute[1];
      if (taskPeriod == 'PM' && taskTimeHour != 12) {
        taskTimeHour += 12;
      }

      if (currentYear < taskDateYear) {
        continue;
      }
      if (currentMonth < taskDateMonth) {
        continue;
      }
      if (currentDay < taskDateDay) {
        continue;
      }
      if (currentHour < taskTimeHour) {
        continue;
      }
      if (currentMinute < taskTimeMinute) {
        continue;
      }

      if (currentYear == taskDateYear) {
        if (currentMonth == taskDateMonth) {
          if (currentDay == taskDateDay) {
            if (currentHour == taskTimeHour) {
              if (currentMinute <= taskTimeMinute) {

              }
              else {
                await TaskDatabase().setTaskExpired(uid: clientEmail, taskId: _items[i].taskId);
                continue;
              }
            }
            else {
              await TaskDatabase().setTaskExpired(uid: clientEmail, taskId: _items[i].taskId);
              continue;
            }
          }
          else {
            await TaskDatabase().setTaskExpired(uid: clientEmail, taskId: _items[i].taskId);
            continue;
          }
        }
        else {
          await TaskDatabase().setTaskExpired(uid: clientEmail, taskId: _items[i].taskId);
          continue;
        }
      } 
      else {
        await TaskDatabase().setTaskExpired(uid: clientEmail, taskId: _items[i].taskId);
        continue;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_items.isNotEmpty) {
        checkForExpiredTask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeProvider>(context);
    final isDark = (_theme.getTheme() == ThemeData.dark());
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.5,
          color: isDark ? Colors.lightBlue : Colors.blue,
          indent: 30,
          endIndent: 30,
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => const NewTask());
          },
          child: Container(
            height: _height * 0.08,
            width: _width * 0.75,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF84d7f5), Color(0xFF5c91ed)]
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFF6895e3),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Expanded(flex: 30, child: Icon(Icons.task_outlined, size: 35)),
                Expanded(flex: 70, child: Text('Add New Task', style: GoogleFonts.comicNeue(fontSize: 32, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ),

        // ...........................................................................

        // Animated Grid Will Come Here

        Expanded(
          child: StreamBuilder(
            stream: TaskDatabase().getPendingTasks(uid: clientEmail),
            builder: (BuildContext context, AsyncSnapshot<List<ToDo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const CircleLoading();
              }
              
              return (snapshot.data!.isEmpty)?
                Center(
                  child: SizedBox(
                    height: 150,
                    child: Column(
                      children: <Widget>[
                        const Expanded(child: Icon(Icons.add_task, size: 100,)),
                        Text('No Task To Do!',style: GoogleFonts.mcLaren(fontSize: 30),)
                      ],
                    ),
                  ),
                ):
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      _items = snapshot.data ?? [];
                      return ToDoTile(todo: snapshot.data![index], snapshot: snapshot, index: index);
                    },
                  ),
                );
            }
          ),
        ),

        // ...........................................................................

      ],
    );
  }
}