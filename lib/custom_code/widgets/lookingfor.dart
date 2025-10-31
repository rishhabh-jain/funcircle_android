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

import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

class Lookingfor extends StatefulWidget {
  const Lookingfor({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _RADIOButtonState createState() => _RADIOButtonState();
}

class _RADIOButtonState extends State<Lookingfor> {
  List<String> buttonList = [
    "A relationship",
    "Casual",
    "Dont’know yet",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(10),
      child: CustomRadioButton(
        buttonLables: buttonList,
        buttonValues: buttonList,
        radioButtonValue: (value, index) {
          print("Button value " + value.toString());
          print("Integer value " + index.toString());
        },
        horizontal: true,
        enableShape: true,
        buttonSpace: 6,
        buttonColor: Colors.white,
        selectedColor: Colors.pink,
        buttonWidth: 400,
      ),
    );
  }
}
