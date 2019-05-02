import 'dart:async';
import 'dart:convert';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/asset.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/network_util.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:kore_app/utils/s3bucketUploader.dart';



class Api {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL =
      "https://w4c7snxw32.execute-api.us-east-2.amazonaws.com/Prod/api/";
  static final ACCOUNT_URL = BASE_URL + "Accounts/";
  static final ORGANIZATION_URL = BASE_URL + "Organization/";
  static final TASK_URL = BASE_URL + "Tasks/";
  static final LOGIN_URL = BASE_URL + "signin";
  static final USER_URL = BASE_URL + "Users/api/getUser/";
  static final ASSET_URL = BASE_URL + "Files/";
  static final S3_URL = BASE_URL + "S3Bucket/";
  // static String token;
  // static final _API_KEY = "somerandomkey";

//make it a sigleton
  static Api _instance = new Api.internal();
  Api.internal();
  factory Api() => _instance;

//return toke
  Future<String> login(String username, String password) {
    String url = LOGIN_URL + "?username=" + username + "&password=" + password;
    return _netUtil.post(url, true).then((dynamic res) {
      return res;
    });
  }

  Future<List<Account>> getAccountsById(
      Future<String> token, Future<User> user) async {
    String _token = await token;
    User _user = await user;
    return _netUtil
        .get(ACCOUNT_URL + "user/" + _user.id.toString(), _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<Account>((json) => new Account.fromJson(json)).toList();
    });
  }

  Future<double> getPercentageOfTasksCompleted
    (Future<String> token, Future<User> user, Account account) async {
    String _token = await token;
    User _user = await user;
    return _netUtil.get(ACCOUNT_URL + "account/" + account.id.toString() + "/user/" + _user.id.toString(), _token).then((dynamic res) {
      print("HELLO THERE NELSON " + res.toString());
      return res;
    });
  }

  Future<List<Task>> getTasks(Future<String> token, Future<User> user) async {
    String _token = await token;
    User _user = await user;
    return _netUtil
        .get(TASK_URL + "user/" + _user.id.toString(), _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<Task>((json) => new Task.fromJson(json)).toList();
    });
  }

  Future<List<Task>> getAllTasksByAccountId(
      Future<String> token, Account account) async {
    String _token = await token;
    return _netUtil
        .get(TASK_URL + "account/" + account.id.toString(), _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<Task>((json) => new Task.fromJson(json)).toList();
    });
  }

  Future<List<Organization>> getOrganizations(Future<String> token) async {
    String _token = await token;
    return _netUtil.get(ORGANIZATION_URL, _token).then((dynamic res) {
      return res
          .map<Organization>((json) => new Organization.fromJson(json))
          .toList();
    });
  }

  Future<User> getUserByUsername(
      Future<String> token, Future<String> username) async {
    String _token = await token;
    String _username = await username;
    return _netUtil.get(USER_URL + _username, _token).then((dynamic res) {
      print(res.toString());
      return User.fromJson(res);
    });
  }

  Future<List<Asset>> getAssets(Future<String> token, String taskId) async {
    String _token = await token;
    return await _netUtil.get(ASSET_URL + "task/" + taskId, _token).then((dynamic res) {
      print("File Get Result: " + res.toString());
      return res.map<Asset>((json) => new Asset.fromJson(json)).toList();
    });
  }

  Future<int> postAsset(Future<String> token, Asset asset, User user) async {
    String _token = await token;

    bool updateTrue;

    var headers = {
      "Content-Type": "application/json",      
      HttpHeaders.authorizationHeader: "Bearer " + _token.trim()
    };

    var body =  asset.toJson(user);
    var bodyEncoded = json.encode(body);
    
    try {
    await _netUtil.post(ASSET_URL, true, headers: headers, body: bodyEncoded).then((dynamic res) {
      print("File Post Result: " + res.toString());
      if (res.statusCode == 200)
      {
        updateTrue = true;
      }         
    });
    } catch (e){
        print(e);
        return 0;
    }
    if (updateTrue) {
      return 2;
    }

    return 1;
  }

  Future<bool> deleteAssetS3(Future<String> token, Asset asset) async {
    
    String _token = await token;

    //Delete File From S3
    bool s3Success = false;
    try {
      await _netUtil.delete(S3_URL + asset.location + "/" + asset.fileName, _token).then((dynamic res) {
      print("File S3 Delete Result: " + res.toString());
      s3Success = true;
      print ("S3 Success v");
      print (s3Success);        
    });
    } catch (e) {
      print(e);
      s3Success = false;
    }
    return s3Success;
  }


  Future<bool> deleteAssetDb(Future<String> token, Asset asset) async {
    String _token = await token;

      try {
        await _netUtil.delete(ASSET_URL + asset.id, _token).then((dynamic res) {
        print("File MySql Delete Result: " + res.toString());        
      });
      } catch (e) {
        print(e);
        return false;
      }
      return true;
  }



  // Future<Task> getTaskById(Future<String> token, Future<Task> task) async {
  //   String _token = await token;
  //   Task _task = await task;
  //   return _netUtil.get(USER_URL + _task.id.toString(), _token).then((dynamic res) {
  //     print(res.toString());
  //     return User.fromJson(res);
  //   });
  // }

  Future<List<Account>> getAccountsByOrgId(
      Future<String> token, Organization org) async {
    String _token = await token;
    return _netUtil
        .get(ACCOUNT_URL + 'user/' + org.id.toString(), _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<Account>((json) => new Account.fromJson(json)).toList();
    });
  }
}
