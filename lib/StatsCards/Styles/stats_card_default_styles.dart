import 'package:flutter/material.dart';

class StatsCardDefaultStyles {
  static headerTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black,
    );
  }

  static bodyTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 10000,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black,
    );
  }

  static footerTextStyle({Color? color}) {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.black,
    );
  }
}
