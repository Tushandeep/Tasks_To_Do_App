import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CircleLoading extends StatefulWidget {
  const CircleLoading({ Key? key }) : super(key: key);

  @override
  _CircleLoadingState createState() => _CircleLoadingState();
}

class _CircleLoadingState extends State<CircleLoading> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 130,
        width: 130,
        child: SpinKitDualRing(
          size: 100,
          duration: Duration(seconds: 1),
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}