import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:tasktodo_app/constants/gloabal_var.dart';
import 'package:tasktodo_app/model/todo.dart';
import 'package:tasktodo_app/services/firebase_database.dart';
import 'package:tasktodo_app/services/theme_provider.dart';
import 'package:tasktodo_app/widgets/square_loading.dart';

class NewTask extends StatefulWidget {
  const NewTask({ Key? key }) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isLoading = true;


  final _formKey = GlobalKey<FormState>();

  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDate = TextEditingController();
  final TextEditingController _taskTime = TextEditingController();
  final TextEditingController _taskDesc = TextEditingController();

  final List<String> _amPm = ['AM', 'PM'];

  ValueNotifier<DateTime> dateNotifier = ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<TimeOfDay> timeNotifier = ValueNotifier<TimeOfDay>(TimeOfDay.now());

  bool dateChanged = false;
  var confirmedDate = "Task Date...";

  bool timeChanged = false;
  var confirmedTime = "Task Time...";
  var taskTimeAlloted = "";

  bool emptyField = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState((){isLoading = false;});
    });
  }

  taskDateWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 50,
          width: 80,
          child: AlertDialog(
            title: Text('Warning!', style: GoogleFonts.mcLaren(fontSize: 25,)),
            content: SizedBox(
              height: 100,
              child: Center(
                child: Text('Please Enter Task Date...', style: GoogleFonts.mcLaren(fontSize: 20,)),
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('OK', style: GoogleFonts.mcLaren()),
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeProvider>(context);
    final isDark = (_theme.getTheme() == ThemeData.dark());
    final _phoneHeight = MediaQuery.of(context).size.height;
    final _phoneWidth = MediaQuery.of(context).size.height;
    return isLoading? const Scaffold(
      body: SquareLoading(),
    )
    : Scaffold(
       appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: GradientText('New Task', style: GoogleFonts.pacifico(fontSize: 37), colors: const [Colors.lightBlueAccent, Colors.blueAccent]),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Divider(
              thickness: 1.5,
              color: isDark ? Colors.lightBlue : Colors.blue,
              indent: 60,
              endIndent: 60,
            ),
        
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: _phoneWidth - 20,
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          style: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                          validator: (val) {
                            if (val!.isEmpty) {return 'Task Name Required';} return null;
                          },
                          controller: _taskName,
                          decoration: InputDecoration(
                            labelText: 'Task Name',
                            hintText: 'Task Name',
                            labelStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                            hintStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                color: isDark? Colors.white: Colors.black,
                                splashRadius: 1.0,
                                icon: const Icon(Icons.task_outlined),
                              ),
                            ),
            
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: _phoneHeight * 0.04),
                        Row(
                          children: [
                            Expanded(
                              flex: 75,
                              child: TextFormField(
                                style: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                enabled: false,
                                controller: _taskDate,
                                decoration: InputDecoration(
                                  labelText: (dateChanged)? 'Task Date...' : null,
                                  hintText: (dateChanged)? _taskDate.text : 'Task Date...',
                                  labelStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                  hintStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                  filled: true,
                                  fillColor: Colors.transparent,
                            
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 25,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  border: const Border(
                                    top: BorderSide(color: Colors.blueAccent, width: 2),
                                    left: BorderSide(color: Colors.blueAccent, width: 2),
                                    right: BorderSide(color: Colors.blueAccent, width: 2),
                                    bottom: BorderSide(color: Colors.blueAccent, width: 2),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                        
                                    await showRoundedDatePicker(
                                      context: context,
                                      height: _phoneHeight * 0.5,
                                      firstDate: DateTime(2021, 1, DateTime.now().day - 1),
                                      initialDate: dateNotifier.value,
                                      lastDate: DateTime(2500, 1, 1),
                                      textPositiveButton: "OK",
                                      textNegativeButton: "CANCEL",
                                      textActionButton: "CLEAR",
                                      onTapActionButton: () {
                                        _taskDate.text = '';
                                        dateChanged = false;
                                        confirmedDate = "";
                                        dateNotifier.value = DateTime.now();
                                        Navigator.of(context).pop();
                                        setState((){});
                                      },
                                    ).then((DateTime? dateTime) {
                                      if (dateTime != null){
                                        dateNotifier.value = dateTime;
                                        confirmedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
                                        _taskDate.text = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
                                      }
                                    });
                                    setState((){});
                                  },
                                  color: isDark? Colors.white: Colors.black,
                                  splashRadius: 1.0,
                                  icon: const Icon(Icons.calendar_today_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _phoneHeight * 0.04),
                        Row(
                          children: [
                            Expanded(
                              flex: 75,
                              child: TextFormField(
                                enabled: false,
                                style: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                controller: _taskTime,
                                decoration: InputDecoration(
                                  labelText: (timeChanged)? 'Task Time...' : null,
                                  hintText: (timeChanged)? _taskTime.text : 'Task Time...',
                                  filled: true,
                                  labelStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                  hintStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                  fillColor: Colors.transparent,
                            
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 25,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  border: const Border(
                                    top: BorderSide(color: Colors.blueAccent, width: 2),
                                    left: BorderSide(color: Colors.blueAccent, width: 2),
                                    right: BorderSide(color: Colors.blueAccent, width: 2),
                                    bottom: BorderSide(color: Colors.blueAccent, width: 2),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    await showRoundedTimePicker(
                                      context: context,
                                      initialTime: timeNotifier.value,
                                      leftBtn: "CLEAR",
                                      onLeftBtn: () {
                                        _taskTime.text = "";
                                        confirmedTime = "";
                                        timeNotifier.value = TimeOfDay.now();
                                        Navigator.of(context).pop();
                                        setState((){});
                                      },
                                    ).then((TimeOfDay? time) {
                                      if (time != null) {
                                        timeNotifier.value = time;
                                        confirmedTime = '${time.hour}:${time.minute} ${_amPm[time.period.index]}';

                                        String _finalTime = "";
                                        if (time.hour > 12){
                                          if (time.minute >= 0 && time.minute <= 9){
                                            _finalTime = "${time.hour - 12}:0${time.minute} ${_amPm[time.period.index]}";  
                                          }
                                          else{
                                            _finalTime = "${time.hour - 12}:${time.minute} ${_amPm[time.period.index]}";
                                          }
                                        }
                                        else{
                                          if (time.minute >= 0 && time.minute <= 9){
                                            _finalTime = "${time.hour}:0${time.minute} ${_amPm[time.period.index]}";  
                                          }
                                          else{
                                            _finalTime = confirmedTime;
                                          }
                                        }
                                        if (_finalTime.contains("AM") && _finalTime[0] == "0"){
                                          _finalTime = _finalTime.substring(1);
                                          _finalTime = "12" + _finalTime;
                                          _taskTime.text = _finalTime;
                                          taskTimeAlloted = "12:00 AM";
                                        }
                                        else {
                                          _taskTime.text = _finalTime;
                                          taskTimeAlloted = _finalTime;
                                        }
                                      }
                                    });
                                    setState(() {});
                                  },
                                  color: isDark? Colors.white: Colors.black,
                                  splashRadius: 1.0,
                                  icon: const Icon(Icons.access_time),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _phoneHeight * 0.03),
                        Container(
                          constraints: BoxConstraints(maxHeight: _phoneHeight * 0.3),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(0, 11, 0, 0),
                            child: TextFormField(
                              style: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                              controller: _taskDesc,
                              minLines: 6,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                hintText: 'Subject',
                                labelStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                hintStyle: GoogleFonts.mcLaren(color: isDark? Colors.white: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 10, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: _phoneHeight * 0.07,
                    width: _phoneWidth * 0.13,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.lightBlueAccent,
                      child: const Text('Add', style: TextStyle(fontSize: 20,)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_taskDate.text == ""){
                            taskDateWarning(context);
                          }
                          else{
                            final taskDate = "${dateNotifier.value.day}-${dateNotifier.value.month}-${dateNotifier.value.year}";
                            final ToDo todo = ToDo(
                              taskName: _taskName.text.trim(),
                              taskDate: taskDate.trim(),
                              taskTime: (taskTimeAlloted != "") ? taskTimeAlloted.trim() : "None",
                              taskDesc: _taskDesc.text.trim(),
                              done: false,
                              expired: false,
                            );
                            
                            TaskDatabase().setTask(uid: clientEmail, todo: todo);
                          
                            _taskName.text = "";
                            _taskDate.text = "";
                            _taskTime.text = "";
                            confirmedTime = "";
                            confirmedDate = "";
                            _taskDesc.text = "";
                            dateNotifier.value = DateTime.now();
                            timeNotifier.value = TimeOfDay.now();
                            setState(() {});
                            Navigator.of(context).pop();
                          }
                        }
                        setState((){});
                      },
                    ),
                  ),
                  SizedBox(width: _phoneWidth * 0.05),
                  SizedBox(
                    height: _phoneHeight * 0.07,
                    width: _phoneWidth * 0.13,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 20,)),
                      color: Colors.blueAccent,
                      onPressed: () {
                        _taskName.text = "";
                        _taskDate.text = "";
                        _taskTime.text = "";
                        confirmedTime = "";
                        confirmedDate = "";
                        _taskDesc.text = "";
                        dateNotifier.value = DateTime.now();
                        timeNotifier.value = TimeOfDay.now();
                        Navigator.of(context).pop();
                        setState((){});
                      },
                    ),
                  ),
                ],
              ),
            ),
      
          ],
        ),
      ),
    );
  }
}