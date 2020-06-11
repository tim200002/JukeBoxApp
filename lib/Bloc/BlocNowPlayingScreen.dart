

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Event/EventsNowPlayigScreen.dart';
import 'package:jukebox/State/StateNowPlayingScreen.dart';


//Bloc isnt ideal here
class BlocNowPlayingScreen extends Bloc<NowPlayingScreenEvents, NowPlayingScreenStates>{
  @override
  NowPlayingScreenStates get initialState => ShowNowPaylingScreen();

  @override
  Stream<NowPlayingScreenStates> mapEventToState(NowPlayingScreenEvents event)async*{
    if(event is EventUpdateData){
      //Pull New Data from API then update the Screen
    }
  }
}