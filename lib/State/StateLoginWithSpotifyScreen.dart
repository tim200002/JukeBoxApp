import 'package:flutter/cupertino.dart';

abstract class LoginWithSpotifyScreenStates{}

class NotLoggedIn extends LoginWithSpotifyScreenStates{}

class InWebView extends LoginWithSpotifyScreenStates{
  final String url;
  InWebView({@required this.url});
}

class LoggedIn extends LoginWithSpotifyScreenStates{} 