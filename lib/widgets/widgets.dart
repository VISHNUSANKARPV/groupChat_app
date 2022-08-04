import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2)),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan, width: 2)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2)),
);

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: "ok",
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

const Color kPrimaryLight = Color(0xFFEDEEF7);
const Color kPrimary = Color(0xFF5B60BA);
const Color kPrimaryDark = Color(0xFF000036);
const Color kGreyLight = Color(0xFFB4B7BF);

