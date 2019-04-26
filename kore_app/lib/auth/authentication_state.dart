import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {}

class AuthenticationUninitialized extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUninitialized';
}

class AuthenticationAuthenticatedAdmin extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticatedAdmin';
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationAuthenticatedRegular extends AuthenticationState {
  @override
  String toString() => 'AuthenticationAuthenticatedRegular';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}