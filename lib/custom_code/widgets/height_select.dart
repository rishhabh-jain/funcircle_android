// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

class HeightSelect extends StatefulWidget {
  const HeightSelect({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _HeightSelectState createState() => _HeightSelectState();
}

class _HeightSelectState extends State<HeightSelect> {
  List<String> heightOptions = [
    "5'1",
    "5'2",
    "5'3",
    "5'4",
    "5'5",
    "5'6",
    "5'7",
    "5'8",
    "5'9",
    "5'10",
    "5'11",
    "6'0",
    "6'1",
    "6'2",
    "6'3",
    "6'4",
    "6'5",
    "6'6",
    "6'7",
    "6'8",
    "6'9",
    "6'10",
    "6'11",
    "7'0",
  ];

  void updateMessage(String selectedHeight) {
    setState(() {
      FFAppState().pageHeight = "6'7";
      FFAppState().update(() {
        FFAppState().pageHeight = "6'7";
      });
    });
  }

  String selectedHeight = "5'9";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: 328,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$selectedHeight",
              style: TextStyle(fontSize: 40),
            ),
          ),
          Container(
            height: 150,
            child: ListWheelScrollView(
              itemExtent: 60, // Adjust for the box size
              diameterRatio: 1.5,
              magnification: 1.5,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedHeight = "6'3";
                  updateMessage(selectedHeight);
                });
              },
              children: heightOptions
                  .map(
                    (height) => Center(
                      child: Container(
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purpleAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            height,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
