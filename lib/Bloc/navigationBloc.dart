//This Bloc is there to handle the Navigation between the Main Screens
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class NavigationEvents {}

class NavigateToNowPlayingScreen extends NavigationEvents {
  final String partyId;
  final String partyName;
  final bool isAdmin;
  NavigateToNowPlayingScreen(
      {@required this.isAdmin,
      @required this.partyId,
      @required this.partyName});
}

class NavigateToWelcomeScreen extends NavigationEvents {}

class NavigateToMyPartyScreen extends NavigationEvents {}

class NavigateToLoginWithSpotifyScreen extends NavigationEvents {}

class NavigateToShowMyPartiesScreen extends NavigationEvents {}

class NavigateToJoinPartyScreen extends NavigationEvents{}

class CreateParty extends NavigationEvents {}

abstract class NavigationStates {}

class StateNowPlayingScreen extends NavigationStates {
  final String partyId;
  final String partyName;
  final bool isAdmin;
  final String userId;
  StateNowPlayingScreen(
      {@required this.isAdmin,
      @required this.partyId,
      @required this.partyName,
      @required this.userId});
}

class StateWelcomeScreen extends NavigationStates {}

class StateLoginWithSpotifyScreen extends NavigationStates {}

class StateShowMyPartiesScreen extends NavigationStates {}

class StateShowCreatePartyScreen extends NavigationStates {}

class StateJoinPartyScreen extends NavigationStates{}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => StateWelcomeScreen();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    if (event is NavigateToWelcomeScreen) {
      yield StateWelcomeScreen();
    } else if (event is NavigateToNowPlayingScreen) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('userId');
      yield StateNowPlayingScreen(
          partyId: event.partyId,
          isAdmin: event.isAdmin,
          partyName: event.partyName,
          userId: userId);
    } else if (event is NavigateToLoginWithSpotifyScreen) {
      yield StateLoginWithSpotifyScreen();
    } else if (event is NavigateToShowMyPartiesScreen) {
      yield StateShowMyPartiesScreen();
    } else if (event is CreateParty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");
      var response = await http
          .get(NetworkConfig().apiAdress + "/Spotify/isConnected?_id=$userId");
      if (response.statusCode != 200) {
        log("Error Validating API");
      } else {
        bool isConnected = json.decode(response.body)['isConnected'];
        log("is Connected: " + isConnected.toString());
        if (isConnected) {
          log("User Valid Show Create Party Screen");
          yield StateShowCreatePartyScreen();
        } else {
          log("No Valid User Show Screen");
          yield StateLoginWithSpotifyScreen();
        }
      }
    }
    else if(event is NavigateToJoinPartyScreen){
      yield StateJoinPartyScreen();
    }
  }
}
