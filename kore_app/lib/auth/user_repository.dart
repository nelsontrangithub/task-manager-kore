import 'package:kore_app/utils/cognito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final storage = new FlutterSecureStorage();
  // RestDatasource source = new RestDatasource();
  String token;
  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    token = await Cognito.getToken(username, password);
    return token;
    // return 'token';
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    await storage.delete(key: 'token');
    return;
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await storage.write(key: 'token', value: token);
    return;
  }

  Future<bool> hasToken() async {
    /// read from keystore/keychain
    String tokenFromKeyChain = await storage.read(key: 'token');
    print(tokenFromKeyChain);
    return token == tokenFromKeyChain;
  }
}