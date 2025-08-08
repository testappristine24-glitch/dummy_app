import 'package:delivoo/AppConstants.dart';
import 'package:delivoo/Auth/login_navigator.dart';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Custom_exception.dart';
import 'package:delivoo/main.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivoo/Models/CookieModel.dart';

class ApiProvider {
  String? _baseUrl = BaseUrl;
  Cookie? cook;

  //prefs
  getToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    return _pref.getString("token");
  }

  getCookie() async {
    var res;
    print(_baseUrl! + GET_COOKIES + '--------api');
    //print(requestJson + '----------requestjson');
    try {
      final response = await http.post(Uri.parse(_baseUrl! + GET_COOKIES),
          body: jsonEncode({"cmemno": "4"}),
          headers: {
            //"Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      res = json.decode(response.body)["d"]["Cookieslist"];
      print('res = ' + res);
      return res;
      // print(json.decode(json.decode(response.body)["d"]["Cookieslist"]));
      // responseJson = _response(response, GET_COOKIES);
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      hideLoading();

      showMessage('No Internet connection');
      //throw FetchDataException('No Internet connection');
    }
  }

  //Social Auth get
  Future<dynamic> authGet(
    String url,
    String username,
    String password,
  ) async {
    var responseJson;
    try {
      print('Calling $url');

      final response = await http
          .get(
            Uri.parse(
              url,
            ),
            headers: {
              'authorization':
                  'Basic ' + base64.encode(utf8.encode('$username:$password')),
              "Content-Type": "application/json",
            },
          )
          .timeout(
            Duration(seconds: 30),
          )
          .onError((error, stackTrace) {
            showSnackBar(
                context: navigatorKey.currentContext!,
                content: "No Internet Connection Found. check your connection");
            throw error.toString();
          });
      print('reposne = ' + response.statusCode.toString());
      responseJson = _response(response, url);
    } on SocketException {
      //throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future get
  Future<dynamic> get(String url) async {
    var responseJson;
    // String token = await getToken();
    try {
      //showLoading();
      final response = await http
          .get(Uri.parse(_baseUrl! + url), headers: {
            // "Authorization": Authorization,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Cache-Control': 'no-cache',
          })
          .timeout(Duration(seconds: 30))
          .onError((error, stackTrace) {
            hideLoading();
            throw error.toString();
          });
      responseJson = _response(response, url);
      print(_baseUrl! + url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //delete
  Future<dynamic> delete(String url) async {
    var responseJson;
    String token = await getToken();
    try {
      //showLoading();
      final response = await http
          .delete(Uri.parse(_baseUrl! + url), headers: {
            "Authorization": token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          })
          .timeout(Duration(seconds: 30))
          .onError((error, stackTrace) {
            hideLoading();
            throw error.toString();
          });
      responseJson = _response(response, url);
      print(_baseUrl! + url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  //future post
  Future<dynamic> post(String url, requestJson) async {
    // var cookie = await getCookie();
    // var cookie =
    // '.ASPNETAUTH=010247697CBFFFF1D908FE47C74C7200F2D9080007730074006900770061007200790000012F00FF';
    //print('cookie value ' + cookie.toString());
    var responseJson;
    //String token = await getToken();
    //print(token + '--------token');
    print(_baseUrl! + url + '--------api');
    // print(requestJson + '----------requestjson');
    try {
      final response = await http
          .post(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        //"Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // 'Cookie': cookie,
      });
      print('reposne = ' + response.statusCode.toString());
      responseJson = _response(response, url);
      return responseJson;
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      //showMessage('No Internet connection');
      //hideLoading();
      noInternet();
      //throw FetchDataException('No Internet connection');
    }
  }

  //future put
  Future<dynamic> put(String url, requestJson) async {
    var responseJson;
    String token = await getToken();
    print(_baseUrl! + url);
    try {
      final response = await http
          .put(Uri.parse(_baseUrl! + url), body: requestJson, headers: {
        "Authorization": token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      responseJson = _response(response, url);
    } on SocketException {
      //Get.defaultDialog(title: 'No Internet connection',middleText: 'I guess your Internet is not availble!');
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putImage(String url, image) async {
    String token = await getToken();
    print(_baseUrl! + url);

    var request =
        new http.MultipartRequest("PUT", (Uri.parse(_baseUrl! + url)));
    var pic = await http.MultipartFile.fromPath("files", image.path);
    request.files.add(pic);
    request.headers["Authorization"] = token;
    var response = await request.send();
    return response;
  }

  dynamic _response(http.Response response, String url) async {
    //BuildContext context;
    var res = json.decode(response.body)["Message"];
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(utf8.decode(response.bodyBytes));
        print(responseJson.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        hideLoading();
        showMessage(response.body.toString());
        break;
      case 403:
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        _prefs.clear();
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => LoginNavigator()),
            (route) => false);
        throw UnauthorisedException(response.body.toString());
      //showMessage(response.body.toString());
      //break;
      case 404:

      case 500:
        print(res);
        showMessage('Some error occured');

        return res;
      default:
        showMessage('Network issue.Please try after some time');
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode} in url : $url');
    }
  }
}

void onError(error) {
  return showMessage('');
}
