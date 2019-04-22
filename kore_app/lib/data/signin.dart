import 'dart:async';
import 'package:kore_app/utils/network_util.dart';
import 'package:kore_app/models/loginCredential.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://l8p4xmnc22.execute-api.us-east-1.amazonaws.com";
  static final LOGIN_URL = BASE_URL + "/prod";
  static final _API_KEY = "somerandomkey";

//return token
  Future<String> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      return res["token"];
    });
  }

  Future<TestData> test() {
    return _netUtil.get(LOGIN_URL).then((dynamic res) {
      print(res.toString());
      return new TestData.constructList(res);
    });
  }
}
