import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:jukebox/Event/EventsLoginWithSpotifyScreen.dart';
import 'package:jukebox/State/StateLoginWithSpotifyScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BlocLoginWithSpotifyScreen
    extends Bloc<LoginWithSpotifyScreenEvents, LoginWithSpotifyScreenStates> {
  @override
  LoginWithSpotifyScreenStates get initialState => NotLoggedIn();

  @override
  Stream<LoginWithSpotifyScreenStates> mapEventToState(
      LoginWithSpotifyScreenEvents event) async* {
    /*if (event is EventLoginWithSpotify) {
      //Get user id from Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");
      //Get adress
      var response = await http
          .get(NetworkConfig().apiAdress + "/LoginSpotify?_id=$userId");
      if (response.statusCode != 200) {
        log("Error Login With Spotify");
      } else {
        String url = json.decode(response.body)["url"];
        log("url");
        //Open Webpage
        if (await canLaunch(url)) {
          await launch(url);
          //Fire Times which periodically checks if logged in
          Timer.periodic(
            Duration(milliseconds: 500),
            (var timer) async {
              log("Timer");
              //Check if logged in
              var response = await http.get(NetworkConfig().apiAdress +
                  "/Spotify/isConnected?_id=$userId");
              if (response.statusCode != 200) {
                log("Error Validating Spotfiy");
                timer.cancel();
              } else {
                bool isConnected = json.decode(response.body)['isConnected'];
                log(isConnected.toString());
                if (isConnected) {
                  log("connected to Spotify");
                  timer.cancel();
                } else {
                  timer.cancel();
                }
              }
            },
          );
          //Logged in -> yield
        } else {
          throw 'Could not launch $url';
        }
      }
    }
    */
    if(event is Validate){
      log("Validate");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");
       var response = await http.get(NetworkConfig().apiAdress +
                  "/Spotify/isConnected?_id=$userId");
      if(response.statusCode!=200){
        log("Error Validating API");
      }
      else{
        bool isConnected = json.decode(response.body)['isConnected'];
        log("is Connected: "+isConnected.toString());
        if(isConnected) {log("yielding");yield LoggedIn();}
        else log("No Valid User");
      }
      yield NotLoggedIn();
    }
    else if(event is abort){
      log("abort");
      yield NotLoggedIn();
    }
    if(event is OpenWebView){

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");
      //Get adress
      var response = await http
          .get(NetworkConfig().apiAdress + "/LoginSpotify?_id=$userId");
      if (response.statusCode != 200) {
        log("Error Login With Spotify");
      } else {
        String url = json.decode(response.body)["url"];
        log("url");
              yield InWebView(url: url);
      }

    }
  }
}
