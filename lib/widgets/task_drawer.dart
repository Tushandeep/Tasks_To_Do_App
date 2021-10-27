import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktodo_app/constants/data.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/screen_info.dart';
import 'package:tasktodo_app/services/theme_provider.dart';

class TaskDrawer extends StatefulWidget {
  const TaskDrawer({ Key? key }) : super(key: key);

  @override
  _TaskDrawerState createState() => _TaskDrawerState();
}

class _TaskDrawerState extends State<TaskDrawer> {

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    clientEmail = prefs.getString('clientEmail') ?? "";
  }


  @override
  void initState() {
    super.initState();
    getUser();
  }


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _theme = Provider.of<ThemeProvider>(context);
    final isDark = (_theme.getTheme() == ThemeData.dark());
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                Expanded(flex: 70, child: Image.asset('assets/task.png', fit: BoxFit.cover,)),
                Expanded(
                  flex: 30,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: isDark ? Colors.white : Colors.black,
                              boxShadow: isDark ? [
                                const BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 3,
                                  spreadRadius: 5,
                                ),
                              ] : [
                                const BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 3,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(clientEmail, style: GoogleFonts.lato(fontSize: 20, color: isDark ? Colors.black : Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  Consumer<ScreenInfo>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GestureDetector(
                          onTap: () {
                            var screenInfo = Provider.of<ScreenInfo>(context, listen: false);
                            screenInfo.updateScreen(screenItems[0]);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.home_outlined),
                              SizedBox(width: _width * 0.03),
                              const Expanded(child: Text('Task To Do', style: TextStyle(fontSize: 17))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  Consumer<ScreenInfo>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GestureDetector(
                          onTap: () {
                            var screenInfo = Provider.of<ScreenInfo>(context, listen: false);
                            screenInfo.updateScreen(screenItems[1]);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.task_alt_outlined),
                              SizedBox(width: _width * 0.03),
                              const Expanded(child: Text('Task Completed', style: TextStyle(fontSize: 17))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  Consumer<ScreenInfo>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: GestureDetector(
                          onTap: () {
                            var screenInfo = Provider.of<ScreenInfo>(context, listen: false);
                            screenInfo.updateScreen(screenItems[2]);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.task_outlined),
                              SizedBox(width: _width * 0.03),
                              const Expanded(child: Text('Task Expired', style: TextStyle(fontSize: 17))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.info_outlined),
                          SizedBox(width: _width * 0.03),
                          const Expanded(child: Text('About Us', style: TextStyle(fontSize: 17))),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if (isDark) {
                          _theme.setTheme(ThemeData.light());
                          prefs.setBool('isTaskDark', false);
                        }
                        else{
                          _theme.setTheme(ThemeData.dark());
                          prefs.setBool('isTaskDark', true);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          isDark ? const Icon(Icons.light_mode_outlined) : const Icon(Icons.dark_mode_outlined),
                          SizedBox(width: _width * 0.03),
                          Expanded(child: Text(isDark ? 'Light Mode' : 'Dark Mode', style: const TextStyle(fontSize: 17))),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 25,
                    endIndent: 25,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}