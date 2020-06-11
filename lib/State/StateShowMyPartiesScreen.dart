import 'package:flutter/cupertino.dart';
import 'package:jukebox/models/party.dart';

abstract class ShowMyPartiesScreenStates{}

class Loading extends ShowMyPartiesScreenStates{}

class PartiesLoaded extends ShowMyPartiesScreenStates{
  final List<Party> parties;

  PartiesLoaded({@required this.parties,});
}