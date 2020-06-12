import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/Screen/SearchScreen.dart';
import 'package:jukebox/ViewModel/NowPlayingScreenViewModell.dart';
import 'package:jukebox/Widgets/NowPlayingTile.dart';
import 'package:provider/provider.dart';

//!Bloc isnt a goog design Pattern for this Screen
//!Overall Bloc is used but this Screen uses Change Notifier
class NowPlayingScreen2 extends StatefulWidget {
  @override
  _NowPlayingScreen2State createState() => _NowPlayingScreen2State();
}

class _NowPlayingScreen2State extends State<NowPlayingScreen2> {

  @override
  void initState() {
    log("init State");
    super.initState();
    // you can uncomment this to get all batman movies when the page is loaded
    Provider.of<NowPlayingigViewModel>(context, listen: false).update();
  }
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NowPlayingigViewModel>(context);
    //vm.update();
    return Scaffold(
      //appBar: AppBar(leading: ,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               IconButton(icon: Icon(Icons.arrow_back),color: Colors.black,onPressed: (){BlocProvider.of<NavigationBloc>(context).add(NavigateToWelcomeScreen());},),
    
              Padding(
                padding: const EdgeInsets.only(left:8.0, bottom: 8),
                child: Text(
                  vm.partyName,
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ),

              //Now playing Area
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("Now Playing")],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (vm.nowPlaying == null)
                      Image.asset(
                        'lib/Assets/musicPlaceholder.jpg',
                        width: 200,
                      )
                    else
                      Image.network(
                        vm.nowPlaying.albumArt,
                        width: 200,
                        fit: BoxFit.fitWidth,
                      )
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (vm.isAdmin) ...[
                    FlatButton(
                        child: Image.asset(
                      "lib/Assets/pause_play.png",
                      height: 50,
                    ),
                    onPressed: (){vm.toggle().catchError((err){log("Error");AlertDialog(title: Text("We coulnt Toggle make sure a Valid Session is runing on a Laptop"),);});},
                    ),
                    FlatButton(
                        child: Image.asset(
                      "lib/Assets/skip.png",
                      height: 50,
                    ),
                    onPressed: (){vm.skip();},
                    )
                  ]
                ],
              ),
              Text("Playlist:"),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                    itemCount: vm.playlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NowPlayingTile(vm: vm, song: vm.playlist[index]);
                    }),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              //Plus Button Could be styled nicer later
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchScreen(partyId: vm.partyId)),
                        ).then((value) => vm.update());
                      },
                      child: Image.asset(
                        "lib/Assets/plus.png",
                        width: 50,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
