import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginWithSpotifyViewModel extends ChangeNotifier {


  bool isConnected = false;


  Future<String> getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    //Get adress
    var response =
        await http.get(NetworkConfig().apiAdress + "/LoginSpotify?_id=$userId");
    if (response.statusCode != 200) {
      log("Error Login With Spotify");
    } else {
      String url = json.decode(response.body)["url"];
      log("url");
      return url;
    }
  }

  validate() async {
    log("Validate");
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
        log("User Valid");
        isConnected=true;
        notifyListeners();
        updateLoginButton();
        
      } else
        log("No Valid User");
    }
  }

//Helper Function Without this Button on Screen wont update
    updateLoginButton() {
    isConnected=true;
    notifyListeners();
  }

  connect() async {
    //Get user id from Shared Preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    //Get adress
    var response =
        await http.get(NetworkConfig().apiAdress + "/LoginSpotify?_id=$userId");
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
            var response = await http.get(
                NetworkConfig().apiAdress + "/Spotify/isConnected?_id=$userId");
            if (response.statusCode != 200) {
              log("Error Validating Spotfiy");
              timer.cancel();
            } else {
              bool isConnected = json.decode(response.body)['isConnected'];
              log(isConnected.toString());
              if (isConnected) {
                log("connected to Spotify");
                timer.cancel();
                isConnected = true;
                notifyListeners();
                log(isConnected.toString());
                log("notify Listeners");
              } else {
                //timer.cancel();
              }
            }
          },
        );
      }
    }
  }
}
