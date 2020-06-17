import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Song{

  String albumArt;
  String title;
  String artist;
  String songId;
  List<String> voters;

  //Constructor To Create Song
  Song({@required this.albumArt
  , @required this.title, @required this.songId, @required this.artist, this.voters});

  //To Map for Json
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      'albumArt': albumArt,
      'songId': songId,
      'artist': albumArt,
      "title": title
    };
    return map;
  }

  Song.fromMap(Map<String,dynamic>map){
    albumArt=map['albumArt'];
    title = map['title'];
    artist = map['artist'];
    songId = map['songId'];
  }

  Song.fromJson(Map<String,dynamic> json):
    albumArt=json['albumArt'],
    title = json['title'],
    artist = json['artist'],
    songId = json['songId']
    {
       var temp = json['voters'];
       voters=new List<String>.from(temp);
    }
   
  
}