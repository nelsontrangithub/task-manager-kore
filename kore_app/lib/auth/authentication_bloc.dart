import 'dart:async';

import 'package:kore_app/utils/jwt_extractor.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/auth/authentication_state.dart';
import 'package:kore_app/auth/authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    // AuthenticationState currentState,
    AuthenticationEvent event,
  ) async* {
      Map<String, dynamic> _claims = Map<String, dynamic>();
    if (event is AppStarted) {
      final String token = await userRepository.hasToken();
      if (token != null) {
        
        _claims = JwtExtractor.parseJwt(token);

        yield AuthenticationAuthenticatedAdmin();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.persistToken(event.token);
      if (event.token != null) {
        _claims = JwtExtractor.parseJwt(event.token);
        if (_claims["cognito:groups"][0] == "Admin") {
          yield AuthenticationAuthenticatedAdmin();
        } else {
          yield AuthenticationAuthenticatedAdmin();
        }
      }
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}
