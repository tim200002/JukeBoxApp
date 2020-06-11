import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:jukebox/Event/EventsShowMyPartiesScreen.dart';
import 'package:jukebox/State/StateShowMyPartiesScreen.dart';
import 'package:jukebox/models/party.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BlocShowMyPartiesScreen extends Bloc<EventShowMyPartiesScreen, ShowMyPartiesScreenStates>{

  @override
  ShowMyPartiesScreenStates get initialState => Loading();

  @override
  Stream<ShowMyPartiesScreenStates> mapEventToState(EventShowMyPartiesScreen event)async*{
    if(event is EventLoadParties){
       SharedPreferences prefs = await SharedPreferences.getInstance();
       String userId = prefs.getString('userId');
       log("Before");
      var response = await http.get(NetworkConfig().apiAdress+"/party/myParties?_id=$userId");
      log("After");
      if(response.statusCode!=200){
        log("Error with API getting all my Parties");
      }
      else{
        List<Party> parties = (json.decode(response.body)as List).map((i)=>Party.fromJson(i)).toList();
        if (parties == null) parties=[]; //Error Handling
        yield PartiesLoaded(parties: parties);
      }
    }
  }
}