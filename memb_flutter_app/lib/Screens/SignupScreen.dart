
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:member_berries/apicalls.dart';

import '../components.dart';
import '../constants.dart';

class SignupScreen extends StatefulWidget {

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController etName = new TextEditingController();
  TextEditingController etUsername = new TextEditingController();
  TextEditingController etPassword = new TextEditingController();
  String nUsername;
  String nPassword;
  String nName;
  ApiCalls api = new ApiCalls();

  void signupAction() async{
    setState(() {
      nUsername = etUsername.text;
      nPassword = etPassword.text;
      nName = etName.text;
    });
    if (!EmailValidator.validate(nUsername)){
      print('Invalid email');
      return;
    }
    Map data = {
      'password' : nPassword,
      'email': nUsername,
      'name': nName
    };
    String body = jsonEncode(data);
    // print(body);
    String url = uri + 'user/signup';
    Map<String, String> headers = {"Content-type": "application/json"};
    http.Response response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200){
      var res_body = jsonDecode(response.body);
      // save token
      // move to another screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Berries'),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                // color: Colors.deepPurple[200],
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/blueberry.jpg'),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.rectangle,
                ),
              )
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Divider(
                    height: 50,
                  ),
                  AppTextBox("Email or Username",etUsername),
                  AppTextBox("Your Name", etName),
                  AppPwdBox("Password",etPassword),
                  ActionButton("Signup", signupAction,Icons.account_box,Colors.deepPurple),
                ],
              )
          )
        ],
      ),
    );
  }
}