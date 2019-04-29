import 'package:kore_app/data/api.dart';
// import 'package:kore_app/utils/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final storage = new FlutterSecureStorage();
  String token;
  // RestDatasource source = new RestDatasource();
  static Map<String, dynamic> claims;
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    // token = await Cognito.getToken(username, password);
    token = await Api().login(username, password);
    await storage.write(key: 'username', value: username);
    return token;
    // return 'token';
  }


  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await storage.delete(key: 'token');
    return;
  }

  Future<String> getUsername() async {
    String name = await storage.read(key: 'username');
    return name;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await storage.write(key: 'token', value: token);
    return;
  }

  Future<String> hasToken() async {
    /// read from keystore/keychain
    String tokenFromKeyChain = await storage.read(key: 'token');
    return tokenFromKeyChain;
  }
}