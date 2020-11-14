
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../components.dart';
import '../constants.dart';
import 'package:member_berries/apicalls.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final api = new ApiCalls();
  TextEditingController etUsername = new TextEditingController();
  TextEditingController etPassword = new TextEditingController();
  String nUsername;
  String nPassword;

  final storage = new FlutterSecureStorage();

  void loginAction() async{
    setState(() {
      nUsername = etUsername.text;
      nPassword = etPassword.text;
    });
    if (!EmailValidator.validate(nUsername)){
      Toast.show("Invalid Email", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      return;
    }
    Map data = {
      'password' : nPassword,
      'email': nUsername
    };
    await storage.deleteAll();
    Map response = await api.postCall(data, 'user/login');
    // print(response);
    if (response['statusCode'] == 200){
      var resBody = response['body'];
      // save token
      // move to another screen
      Toast.show("Login Success", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      await storage.write(key: 'jwt', value: resBody['token']);
      await storage.write(key: 'u_id', value: resBody['id']);
      Navigator.popAndPushNamed(context, '/home');
    }
    else{
      print(response['body']);
      Toast.show("Login failed; authentication failure", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Member Berries'),
        backgroundColor: kBackgroundColor,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
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
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
                          child: AppTextBox("Email or Username",etUsername)
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 40.0),
                          child: AppPwdBox("Password",etPassword)
                      ),
                      ActionButton("Login", loginAction,Icons.lock,Colors.deepPurple),
                      Divider(height: 40,),
                      ActionButton("New User? Sign Up", () => {Navigator.pushNamed(context, '/signup')},Icons.account_box,Colors.deepPurple),
                    ],
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}