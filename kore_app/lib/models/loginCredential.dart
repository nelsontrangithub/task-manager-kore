class LoginCredential {
  String _username;
  String _password;
  LoginCredential(this._username, this._password);

  LoginCredential.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
  }

  String get username => _username;//geter
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

    return map;
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