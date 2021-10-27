import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/enums.dart';
import 'package:tasktodo_app/model/screen_info.dart';
import 'package:tasktodo_app/screens/mini_screens/completed_tasks.dart';
import 'package:tasktodo_app/screens/mini_screens/expired.dart';
import 'package:tasktodo_app/screens/mini_screens/task_to_do.dart';
import 'package:tasktodo_app/services/auth.dart';
import 'package:tasktodo_app/widgets/square_loading.dart';
import 'package:tasktodo_app/widgets/task_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientEmail = prefs.getString('clientEmail') ?? "";
  }

  
  
  @override
  void initState() {
    super.initState();
    
    getUser();
    Future.delayed(const Duration(seconds: 3), () {
      setState((){isLoading = false;});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return isLoading? const Scaffold(
      body: SquareLoading(),
    )
    :Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_outlined),
            ),
          ),
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Consumer<ScreenInfo>(
          builder: (context, value, child) {
            if (value.screenType == ScreenType.incompletedtask) {
              return GradientText('Expired Task', style: GoogleFonts.pacifico(fontSize: 37), colors: const [Colors.lightBlueAccent, Colors.blueAccent]);
            }
            else if (value.screenType == ScreenType.completedtask) {
              return GradientText('Completed Task', style: GoogleFonts.pacifico(fontSize: 36), colors: const [Colors.lightBlueAccent, Colors.blueAccent]);
            }
            return GradientText('Tasks To Do', style: GoogleFonts.pacifico(fontSize: 37), colors: const [Colors.lightBlueAccent, Colors.blueAccent]);
          }
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app_outlined),
              onPressed:() async {
                await AuthService().signOut();
                setState(() {});
              }
            ),
          ),
          const SizedBox(width: 5,),
        ],
      ),
      drawer: const TaskDrawer(),

      body: Consumer<ScreenInfo>(
        builder: (context, value, child) {
          if (value.screenType == ScreenType.incompletedtask) {
            return const TaskIncompleted();
          }
          else if (value.screenType == ScreenType.completedtask) {
            return const TaskCompleted();
          }
          return const TaskToDo();
        }
      ),
    );
  }
}