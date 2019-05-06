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
  static final USER_URL = BASE_URL + "Users/";
  static final ASSET_URL = BASE_URL + "Files/";
  static final S3_URL = BASE_URL + "S3Bucket/";
  static final ALLUSERS_URL = BASE_URL + "Users/";
  static final SEARCH_USER_URL = BASE_URL + "Users/api/search/";
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

  Future<List<User>> getAllUsers(Future<String> token) async {
    String _token = await token;
    return _netUtil.get(ALLUSERS_URL, _token).then((dynamic res) {
      return res.map<User>((json) => new User.fromJson(json)).toList();
    });
  }

  Future<List<Account>> getAccountsById(
      Future<String> token, Future<User> user) async {
    String _token = await token;
    User _user = await user;
    return _netUtil
        .get(ACCOUNT_URL + "user/" + _user.id.toString(), _token)
        .then((dynamic res) {
      return res.map<Account>((json) => new Account.fromJson(json)).toList();
    });
  }

  Future<double> getPercentageOfTasksCompleted(
      Future<String> token, Future<User> user, Account account) async {
    String _token = await token;
    User _user = await user;
    return _netUtil
        .get(
            ACCOUNT_URL +
                "account/" +
                account.id.toString() +
                "/user/" +
                _user.id.toString(),
            _token)
        .then((dynamic res) {
      print(res.toString());
      return res;
    });
  }

  Future<List<Task>> getTasks(
      Future<String> token, Future<User> user, Account account) async {
    String _token = await token;
    User _user = await user;
    return _netUtil
        .get(
            TASK_URL +
                "account/" +
                account.id.toString() +
                "/user/" +
                _user.id.toString(),
            _token)
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
    return _netUtil
        .get(USER_URL + "api/getUser/" + _username, _token)
        .then((dynamic res) {
      return User.fromJson(res);
    });
  }

  Future<List<User>> searchUserByUsername(
      Future<String> token, String username) async {
    String _token = await token;
    String _username = username;
    return _netUtil
        .get(SEARCH_USER_URL + _username, _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<User>((json) => new User.fromJson(json)).toList();
    });
  }

  Future<List<Asset>> getAssets(Future<String> token, String taskId) async {
    String _token = await token;
    return await _netUtil
        .get(ASSET_URL + "task/" + taskId, _token)
        .then((dynamic res) {
      print("File Get Result: " + res.toString());
      return res.map<Asset>((json) => new Asset.fromJson(json)).toList();
    });
  }

  Future<int> postAsset(Future<String> token, Asset asset, User user) async {
    String _token = await token;

    bool updateTrue = false;

    var headers = {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + _token.trim()
    };

    var body = asset.toJson(user);
    var bodyEncoded = json.encode(body);

    try {
      await _netUtil
          .post(ASSET_URL, false,
              headers: headers, body: bodyEncoded, returnResponse: true)
          .then((dynamic res) {
        print("File Post Result: " + res.toString());
        if (res.statusCode == 200) {
          updateTrue = true;
        }
      });
    } catch (e) {
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
      await _netUtil
          .delete(S3_URL + asset.location + "/" + asset.fileName, _token)
          .then((dynamic res) {
        print("File S3 Delete Result: " + res.toString());
        s3Success = true;
        print("S3 Success v");
        print(s3Success);
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
      return res.map<Account>((json) => new Account.fromJson(json)).toList();
    });
  }

  Future<List<User>> getUsersByTaskId(Future<String> token, Task task) async {
    String _token = await token;
    return _netUtil
        .get(USER_URL + 'api/task/' + task.id.toString(), _token)
        .then((dynamic res) {
      print(res.toString());
      return res.map<User>((json) => new User.fromJson(json)).toList();
    });
  }

  Future<bool> assignUserToTask(
      Future<String> token, String taskId, int userId) async {
    String _token = await token;
    var headers = {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + _token.trim()
    };
    var bodyEncoder = json.encode(userId);

    try {
      await _netUtil
          .post(TASK_URL + "user/" + taskId, false,
              headers: headers, body: bodyEncoder)
          .then((dynamic res) {
        print("task membership res" + res.toString());
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unassignUserToTask(
      Future<String> token, int taskId, int userId) async {
    String _token = await token;

    try {
      await _netUtil
          .delete(TASK_URL + "task/" + taskId.toString() + "/user/" + userId.toString(), _token)
          .then((dynamic res) {
        print("task membership res" + res.toString());
      });
      return true;
    } catch (e) {
      print(false);
      return false;
    }
  }

  Future<bool> updateTaskStatus(
      Future<String> token, Task task, int status) async {
    String _token = await token;
    var headers = {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer " + _token.trim()
    };

    var bodyEncoded = json.encode(status);

    return _netUtil
        .put(TASK_URL + task.id.toString(), false,
            headers: headers, body: bodyEncoded)
        .then((dynamic res) {
      print(res);
      return res;
    });
  }

  Future<Task> getTask(Future<String> token, int id) async {
    String _token = await token;
    return _netUtil.get(TASK_URL + id.toString(), _token).then((dynamic res) {
      print(res.toString());
      return res;
    });
  }
}
