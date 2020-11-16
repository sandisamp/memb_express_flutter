import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

final kBackgroundColor = Colors.deepPurple[100];
final kTitleTextColor = Colors.white;
final kTextSubColor = Colors.grey[400];
final kTextStandardColor = Colors.black;
final uri = 'http://192.168.0.100:3000/api/';

final subTextStyle = TextStyle(
  fontSize: 16,
  color: kTextSubColor
);

final standardTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: kTextStandardColor
);


final headingTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: kTitleTextColor
);

