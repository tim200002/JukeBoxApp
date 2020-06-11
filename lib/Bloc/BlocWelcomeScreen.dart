
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:jukebox/Event/EventsWelcomeScreen.dart';
import 'package:jukebox/State/StatesWelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BlocWelcomeScreen extends Bloc<WelcomeScreenEvents, WelcomeScreenStates>{

  @override
  WelcomeScreenStates get initialState => Initializing();

  @override 
  Stream<WelcomeScreenStates> mapEventToState(WelcomeScreenEvents event)async*{
    if(event is EventInitialise){
      //Make all the Checking with unique ID etc
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString("userId");

      //No Key yet
      if(userId == null){
        log("No key yet");
        bool worked = await createUser(prefs);
        if(worked){
          yield(Initialised());
        }
        else{
          //Validate again
        }
      }
      else{
        //Check if key is a valid key
        var response = await http.get(NetworkConfig().apiAdress+"/user/validate?_id=$userId");
        if(response.statusCode !=200){
          log("User Invalid");
          //Create new User
          bool worked = await createUser(prefs);
           if(worked){
             yield(Initialised());
          }
          //Validation missing
        }
        else{
          log("User valid");
          yield(Initialised());
        }
      }
    }
  }

  Future<bool> createUser(SharedPreferences prefs)async {
    var response = await http.post(NetworkConfig().apiAdress+"/user/createNewUser");
        if(response.statusCode !=200){
          log("Error Creating User");
          return false;
        }
        else{
          String userId = json.decode(response.body)["id"];
          prefs.setString("userId", userId);
          return true;
        }
  }

}