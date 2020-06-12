import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jukebox/Configuration/networkConfig.dart';
import 'package:jukebox/models/song.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NowPlayingigViewModel extends ChangeNotifier {
  List<Song> playlist = [];
  Song nowPlaying;
  final bool isAdmin;
  final String partyName;
  final String partyId;
  final String userId;
  //Later this is sytsem Variable

  NowPlayingigViewModel({@required this.isAdmin, @required this.partyName, @required this.partyId, @required this.userId}){
    createWebsocket();
  }

  //Websocket
  IO.Socket socket;

  createWebsocket() {
    log(NetworkConfig().apiAdress + "/appsock");
    socket = IO.io(NetworkConfig().apiAdress + "/appsock", <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on("connect", (_) {
      log("Connected");
      socket.emit('room',
          partyId); //Here to show Servet to join the Room beongig to the Party
    });
    socket.on("update", (_) {
      log("Websocket update");
      update();
    }); //Not ideal later one could Send everything to update in one Message then no API call needed
  }


  //Make all the API Calls
  Future<void> update() async {
    log("update");
    var response =
        await http.get("${NetworkConfig().apiAdress}/party?partyId=$partyId");
    if (response.statusCode != 200) {
      log("Calling Api failed");
      return;
    }
    playlist = (json.decode(response.body) as List)
        .map((i) => Song.fromJson(i))
        .toList();
    if (playlist.length > 0) {
      nowPlaying = playlist[0];
      playlist.removeAt(0);
      notifyListeners();
    }
  }

  Future<void> vote(Song song) async {
    Map data = {
      'id': partyId,
      'songId': song.songId,
      'artist': song.artist,
      'albumArt': song.albumArt,
      'title': song.title
    };

    var body = json.encode(data);
    var response = await http.post("${NetworkConfig().apiAdress}/party/vote",
        headers: {"Content-Type": "application/json"}, body: body);
    if (response.statusCode != 200) {
      log("Calling Api failed");
      return;
    }
    log("voted");
    update();
  }

  Future<void> toggle() async {
    var response = await http.get(
        "${NetworkConfig().apiAdress}/party/toggle?partyId=$partyId&_id=$userId");
    if (response.statusCode != 200) {
      log("Calling Api failed");
      throw("Error Toggling");
    }
    log("toggled");
  }

  Future<void> skip() async {
    var response = await http.get(
        "${NetworkConfig().apiAdress}/party/skip?partyId=$partyId&_id=$userId");
    if (response.statusCode != 200) {
      log("Calling Api failed");
      return;
    }
    log("skipped");
  }
}
