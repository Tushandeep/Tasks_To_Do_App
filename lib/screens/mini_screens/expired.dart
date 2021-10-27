import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/todo.dart';
import 'package:tasktodo_app/services/firebase_database.dart';
import 'package:tasktodo_app/services/theme_provider.dart';
import 'package:tasktodo_app/widgets/circle_loading.dart';
import 'package:tasktodo_app/widgets/todo_tile.dart';

class TaskIncompleted extends StatefulWidget {
  const TaskIncompleted({ Key? key }) : super(key: key);

  @override
  _TaskIncompletedState createState() => _TaskIncompletedState();
}

class _TaskIncompletedState extends State<TaskIncompleted> {
  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeProvider>(context);
    final isDark = (_theme.getTheme() == ThemeData.dark());
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.5,
          color: isDark ? Colors.lightBlue : Colors.blue,
          indent: 30,
          endIndent: 30,
        ),

        // ...........................................................................

        // Animated Grid Will Come Here

        // ...........................................................................

        Expanded(
          child: StreamBuilder(
            stream: TaskDatabase().getExpiredTasks(uid: clientEmail),
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
                        Text('No Task Expired!',style: GoogleFonts.mcLaren(fontSize: 30),)
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
                      return ToDoTile(todo: snapshot.data![index], snapshot: snapshot, index: index);
                    },
                  ),
                );
            }
          ),
        ),


      ],
    );
  }
}