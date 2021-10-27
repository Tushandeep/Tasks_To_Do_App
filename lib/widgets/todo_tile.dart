import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/todo.dart';
import 'package:tasktodo_app/screens/update_existing_task.dart';
import 'package:tasktodo_app/services/firebase_database.dart';
import 'package:tasktodo_app/services/theme_provider.dart';

class ToDoTile extends StatefulWidget {
  final ToDo todo;
  final AsyncSnapshot<List<ToDo>> snapshot;
  final int index;
  const ToDoTile({ Key? key, required this.todo, required this.snapshot, required this.index }) : super(key: key);

  @override
  _ToDoTileState createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {

  bool _animate = false;
  static bool _isStart = true;

  @override
  void initState() {
    super.initState();

    _isStart = true;
    _animate = false;

    _isStart
      ? Future.delayed(Duration(milliseconds: widget.index * 100), () {
          setState(() {
            _animate = true;
            _isStart = false;
          });
        })
      : _animate = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isDark1 = false;

  showInfoDialog(BuildContext context, bool isDark) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Text(widget.todo.taskName, style: GoogleFonts.lato(fontSize: 25)),
               Divider(
                 thickness: 1.5,
                 color: isDark ? Colors.white : Colors.black,
               ),
            ],
          ),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.calendar_today_outlined, size: 16),
                    ),
                    const Text(': ', style: TextStyle(fontSize: 16)),
                    Text(widget.todo.taskDate, style: GoogleFonts.lato(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.alarm_outlined, size: 16),
                    ),
                    const Text(': ', style: TextStyle(fontSize: 16)),
                    Text(widget.todo.taskTime, style:GoogleFonts.lato(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.note_alt_outlined, size: 16),
                    ),

                    const Text(': ', style: TextStyle(fontSize: 16)),
                    Text((widget.todo.taskDesc.isNotEmpty) ? widget.todo.taskDesc : ".....", style: GoogleFonts.lato(fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeProvider>(context);
    final isDark = (_theme.getTheme() == ThemeData.dark());
    isDark1 = isDark;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 1000),
        padding: _animate ? const EdgeInsets.all(4.0) : const EdgeInsets.only(top: 10),
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 25),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20,),
            gradient: const LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: [Colors.lightBlueAccent, Colors.blueAccent].last.withOpacity(0.6),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.task_outlined, size: 40,),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text((widget.todo.taskName.length > 15) ? widget.todo.taskName.substring(0, 15) + "..." : widget.todo.taskName, style: GoogleFonts.lato(fontSize: 25)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.calendar_today_outlined, size: 16),
                          ),
                          const Text(': ', style: TextStyle(fontSize: 16)),
                          Text(widget.todo.taskDate, style: GoogleFonts.lato(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.alarm_outlined, size: 16),
                          ),
                          const Text(': ', style: TextStyle(fontSize: 16)),
                          Text(widget.todo.taskTime, style: GoogleFonts.lato(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),



              (widget.todo.done || widget.todo.expired) ? Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                // margin: const EdgeInsets.symmetric(vertical: 3),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      (widget.todo.expired) ? Container() : IconButton(
                        tooltip: 'Mark as not done',
                        splashRadius: 16,
                        icon: const Icon(Icons.check_circle_outline_outlined, size: 30),
                        onPressed: () async {
                          widget.todo.done = true;
                          await TaskDatabase().markAsUnDoneTask(uid: clientEmail, taskId: widget.todo.taskId);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ) 
              :Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        tooltip: 'Show Description',
                        splashRadius: 16,
                        icon: const Icon(Icons.info_outlined, size: 30),
                        onPressed:() => showInfoDialog(context, isDark),
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        tooltip: 'Mark As Done',
                        splashRadius: 16,
                        icon: const Icon(Icons.radio_button_unchecked_outlined, size: 30),
                        onPressed: () async {
                          widget.todo.done = true;
                          await TaskDatabase().markAsDoneTask(uid: clientEmail, taskId: widget.todo.taskId);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        tooltip: 'Edit Task',
                        splashRadius: 16,
                        icon: const Icon(Icons.mode_edit_outline_outlined, size: 30),
                        onPressed: () {
                          Get.to(() => EditTask(todo: widget.todo, taskId: widget.todo.taskId));
                        }
                      ),
                      IconButton(
                        padding: const EdgeInsets.all(2),
                        tooltip: 'Delete Task',
                        splashRadius: 16,
                        icon: const Icon(Icons.delete_outline_outlined,size: 30),
                        onPressed: () async {
                          await TaskDatabase().deleteTask(widget.snapshot, widget.index, clientEmail);
                        },
                      ),
                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}