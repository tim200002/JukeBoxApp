import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:jukebox/models/song.dart';
import 'package:http/http.dart' as http;

class SearchViewModel extends ChangeNotifier{
  List<Song> playlist =[];
  final String partyId;
  final String userId;
  SearchViewModel({@required this.partyId, @required this.userId});
 
  //Make all the API Calls
  Future<void> search(String query)async{
    log("Search");
    if(query=="") return; //Dont search no String

    Map data = {
      'partyId': partyId,
      'query': query
    };

    var body = json.encode(data);
    var response = await http.post("${NetworkConfig().apiAdress}/search",headers: {"Content-Type": "application/json"},body: body);
    if(response.statusCode!=200){
      log("Calling Api failed");
      return;
    }
    playlist = (json.decode(response.body)as List).map((i)=>Song.fromJson(i)).toList();
    
      notifyListeners();
  }

  Future<void> addSong(Song song)async{
    log(userId);
    Map data = {
      'id': partyId,
      'userId': userId,
      'songId': song.songId,
      'artist': song.artist,
      'albumArt': song.albumArt,
      'title': song.title
    };

    var body = json.encode(data);
    var response = await http.post("${NetworkConfig().apiAdress}/party/vote",headers: {"Content-Type": "application/json"},body: body);
    if(response.statusCode!=200){
      log("Calling Api failed");
      return;
    }
    log("voted");
  }
}