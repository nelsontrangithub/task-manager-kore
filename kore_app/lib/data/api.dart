import 'dart:async';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/utils/network_util.dart';
import 'package:kore_app/models/loginCredential.dart';

class Api {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://w4c7snxw32.execute-api.us-east-2.amazonaws.com/Prod";
  static final ACCOUNT_URL = BASE_URL + "/Accounts/";
  static final ORGANIZATION_URL = BASE_URL + "/Organiztion/";
  static final TASK_URL = BASE_URL + "/Task/";
  // static String token;
  // static final _API_KEY = "somerandomkey";

//try to make it a sigleton
  static Api _instance = new Api.internal();
  Api.internal();
  factory Api() => _instance;

//return toke
  Future<String> login(String username, String password) {
    return _netUtil.post(ACCOUNT_URL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      return res["token"];
    });
  }

Future<dynamic> getAccountsById(Future<String> token) async {
  String _token = await token;
    return _netUtil.get(ACCOUNT_URL, _token).then((dynamic res) {
      print(res.toString());
      return res.map<Account>((json) => new Account.fromJson(json)).toList();
    });
  }

  Future<TestData> test(token) {
    return _netUtil.get(ORGANIZATION_URL, token).then((dynamic res) {
      print(res.toString());
      return new TestData.constructList(res);
    });
  }
}
