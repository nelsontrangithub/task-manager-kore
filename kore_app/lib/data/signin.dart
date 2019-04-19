import 'dart:async';
import 'package:kore_app/utils/network_util.dart';
import 'package:kore_app/models/loginCredential.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://l8p4xmnc22.execute-api.us-east-1.amazonaws.com";
  static final LOGIN_URL = BASE_URL + "/prod";
  static final _API_KEY = "somerandomkey";

  Future<LoginCredential> login(String username, String password) {
    return _netUtil.post(LOGIN_URL, body: {
      "token": _API_KEY,
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      if (res["error"]) throw new Exception(res["error_msg"]);
      return new LoginCredential.map(res["user"]);
    });
  }

  Future<TestData> test() {
    return _netUtil.get(LOGIN_URL).then((dynamic res) {
      print(res.toString());
      return new TestData.constructList(res);
    });
  }
}
