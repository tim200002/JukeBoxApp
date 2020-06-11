import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinPartyViewModel extends ChangeNotifier {
  bool isValidating = false;
  bool validationFailed = false;

  Future<Map> validate(String partyId) async {
    isValidating = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");
    
     Map data={
      "_id": userId,
      "partyId": partyId
    };
    var body = json.encode(data);
    var response = await http.post(NetworkConfig().apiAdress+"/party/join", headers: {"Content-Type": "application/json"}, body: body);

    //Case Party not found
    if(response.statusCode!=200){
      isValidating=false;
      validationFailed=true;
      notifyListeners();
      throw("Couldn't find Party");
    }
    else{
       String partyId=json.decode(response.body)["_id"];
      String partyName = json.decode(response.body)["partyName"];
      return {"partyId": partyId, "partyName": partyName};
    }
  }
}
