import 'package:http/http.dart' as http;
import 'package:member_berries/constants.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiCalls {

  final storage = FlutterSecureStorage();

  Future<Map> postCall (data,url) async {
    url = uri + url;
    String body = jsonEncode(data);
    Map<String, String> headers;
    String jwtToken = await storage.read(key: 'jwt');
    if (jwtToken != null){
      headers = {
        "Content-type": "application/json",
        "auth-token": jwtToken
      };
    }
    else{
      headers = {"Content-type": "application/json"};
    }
    http.Response response = await http.post(url, headers: headers, body: body);
    // print(response.body);

    if (response.statusCode != 200){
      return {
        "body": response.body,
        "statusCode": response.statusCode
      };
    }
    return {
        "body": jsonDecode(response.body),
        "statusCode": response.statusCode
      };
    }

    Future<Map> getCall(data, url) async {
      url = uri + url + '/' + data;
      print(url);
      Map<String,String> headers;
      headers = {
        "Content-type": "Application/Json"
      };
      // print(url);
      http.Response response = await http.get(url,headers: headers);
      // print(response.body);
      if (response.statusCode != 200){
        return {
          "body": response.body,
          "statusCode": response.statusCode
        };
      }
      return {
        "body": jsonDecode(response.body),
        "statusCode": response.statusCode
      };
    }
}
