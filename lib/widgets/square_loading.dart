import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SquareLoading extends StatefulWidget {
  const SquareLoading({ Key? key }) : super(key: key);

  @override
  _SquareLoadingState createState() => _SquareLoadingState();
}

class _SquareLoadingState extends State<SquareLoading> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SpinKitCubeGrid(
            size: 150,
            duration: Duration(seconds: 1),
            color: Colors.orangeAccent,
          )
        ],
      ),
    );  
  }
}