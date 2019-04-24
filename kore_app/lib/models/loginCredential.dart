import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
// class LoginCredential {
//   String _username;
//   String _password;
//   LoginCredential(this._username, this._password);

//   LoginCredential.map(dynamic obj) {
//     this._username = obj["username"];
//     this._password = obj["password"];
//   }

//   String get username => _username;//geter
//   String get password => _password;

//   Map<String, dynamic> toMap() {
//     var map = new Map<String, dynamic>();
//     map["username"] = _username;
//     map["password"] = _password;

//     return map;
//   }
// }

class LoginCredentials {
  final CognitoCredentials _cognitoCredentials;
  final String _token;

  LoginCredentials(String identityPoolId, String userPoolId, String clientId, this._token)
      : _cognitoCredentials = new CognitoCredentials(identityPoolId, new CognitoUserPool(userPoolId, clientId));

  Future<CognitoCredentials> get cognitoCredentials async {
    await _cognitoCredentials.getAwsCredentials(_token);
    return _cognitoCredentials;
  }
}


class TestData {
  int _id;
  String _productName;
  double _price;
  int quantity;

  TestData.map(dynamic obj) {
    this._id = obj["id"];
    this._productName = obj["productName"];
  }

  TestData.constructList(List<dynamic> objs){
    objs.forEach((obj) => TestData.map(obj));
  }
}