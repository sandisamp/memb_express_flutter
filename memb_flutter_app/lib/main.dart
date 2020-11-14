

import 'dart:convert';

import 'package:member_berries/components.dart';
import 'package:member_berries/constants.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

import 'Screens/LoadingScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/ResourceSwiperScreen.dart';
import 'Screens/SignupScreen.dart';
void main() => runApp( MyApp() );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Member Berries',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: TextTheme( bodyText2: TextStyle(
          color: kTextStandardColor,
        ))
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => ResourceSwiper(),
      },
    );
  }
}




