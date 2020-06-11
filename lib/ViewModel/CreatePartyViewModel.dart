

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePartyViewModel extends ChangeNotifier{

  bool isValidating = false;
  bool validationFailed =false;

  //Trys to Create the Party on Succes returns partyId
  //on Failure throws Error
  Future<Map> validate(String partyName)async{
    isValidating = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("userId");

    Map data={
      "_id": userId,
      "name": partyName
    };
    var body = json.encode(data);
    var response =  await http.post(NetworkConfig().apiAdress+"/party", headers: {"Content-Type": "application/json"}, body: body);
    if(response.statusCode!=200){
      isValidating = false;
      validationFailed=true;
      notifyListeners();
      throw("Couldt create the Party");
    }
    else{
      String partyId=json.decode(response.body)["_id"];
      String partyName = json.decode(response.body)["partyName"];
      return {"partyId": partyId, "partyName": partyName};
    }
  }

}