import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/BlocNowPlayingScreen.dart';
import 'package:jukebox/State/StateNowPlayingScreen.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BlocNowPlayingScreen _blocNowPlayingScreen =
        BlocProvider.of<BlocNowPlayingScreen>(context);
    return BlocBuilder<BlocNowPlayingScreen, NowPlayingScreenStates>(
        builder: (context, state) {
      if (state is ShowNowPaylingScreen) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.PartyName, style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                ),

                //Now playing Area
                Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[Text("Now Playing")],),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    if(state.nowPlaying==null)  Image.network('https://picsum.photos/250?image=9',width: 200,)
                    else Image.network(state.nowPlaying.albumArt,width: 200,)
                  ],),
                ),
              
                  Row(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[
                    if(state.isAdmin)...[
                    Text("StartStop"),
                    Text("Skip")]
                  ],)

              ],
            ),
          ),
        );
      }
    });
  }
}
