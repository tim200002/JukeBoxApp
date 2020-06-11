import 'package:jukebox/models/song.dart';

abstract class NowPlayingScreenStates{}

//Initialising

class ShowNowPaylingScreen extends NowPlayingScreenStates{
  List<Song> playlist =[];
  Song nowPlaying;
  String PartyName = "Tims Party";
  bool isAdmin = true;
}