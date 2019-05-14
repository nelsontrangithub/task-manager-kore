import 'package:amazon_cognito_identity_dart/cognito.dart';

class Cognito {
static Future<String> getToken(String username, String password) async {
final userPool = new CognitoUserPool(
    'us-east-2_G26JTdg5h', '6fba0vhhhemve6bq3sm5evd0do');
final cognitoUser = new CognitoUser(
    'admin@kore.com', userPool);
final authDetails = new AuthenticationDetails(
    username: username, password: password);
CognitoUserSession session;
try {
  session = await cognitoUser.authenticateUser(authDetails);
} on CognitoUserNewPasswordRequiredException catch (e) {
  // handle New Password challenge
} on CognitoUserMfaRequiredException catch (e) {
  // handle SMS_MFA challenge
} on CognitoUserSelectMfaTypeException catch (e) {
  // handle SELECT_MFA_TYPE challenge
} on CognitoUserMfaSetupException catch (e) {
  // handle MFA_SETUP challenge
} on CognitoUserTotpRequiredException catch (e) {
  // handle SOFTWARE_TOKEN_MFA challenge
} on CognitoUserCustomChallengeException catch (e) {
  // handle CUSTOM_CHALLENGE challenge
} on CognitoUserConfirmationNecessaryException catch (e) {
  // handle User Confirmation Necessary
} catch (e) {
  print(e);
}
return session.getAccessToken().getJwtToken();
}

}