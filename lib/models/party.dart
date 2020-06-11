import 'package:flutter/cupertino.dart';

class Party{
  final partyName;
  final partyId;
  final isAdmin;

  Party({@required this.partyId, @required this.partyName, @required this.isAdmin});

  Party.fromJson(Map<String,dynamic> json):
  partyName=json["name"],
  partyId=json["partyId"],
  isAdmin=json["isAdmin"];
}