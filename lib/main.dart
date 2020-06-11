import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/BlocShowMyPartiesScreen.dart';
import 'package:jukebox/Bloc/BlocWelcomeScreen.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/Screen/CreatePartyScreen.dart';
import 'package:jukebox/Screen/JoinPartyScreen.dart';
import 'package:jukebox/Screen/NowPlayingScreen2.dart';
import 'package:jukebox/Screen/WelcomeScreen.dart';
import 'package:jukebox/ViewModel/CreatePartyViewModel.dart';
import 'package:jukebox/ViewModel/JoinPartyViewModel.dart';
import 'package:jukebox/ViewModel/LoginWithSpotifyViewModel.dart';
import 'package:provider/provider.dart';

import 'Screen/LoginWithSpotifyScreen.dart';
import 'Screen/ShowMyPartiesScreen.dart';
import 'ViewModel/NowPlayingScreenViewModell.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jukebox',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (BuildContext context)=>NavigationBloc(),
        child: BlocBuilder<NavigationBloc, NavigationStates>(
          builder: (context, state){
            if (state is StateWelcomeScreen){
              return BlocProvider(
                create: (BuildContext context)=>BlocWelcomeScreen(),
                child: WelcomeScreen()
              );
            }
            else if (state is StateNowPlayingScreen){
              /*
              return BlocProvider(
                create: (BuildContext context)=>BlocNowPlayingScreen(),
                child: NowPlayingScreen()
              );*/
              //!Bloc isnt a goog design Pattern for this Screen
              //!Overall Bloc is used but this Screen uses Change Notifier
               return ChangeNotifierProvider(create: (context)=>NowPlayingigViewModel(partyId: state.partyId, partyName: state.partyName, userId: state.userId, isAdmin: state.isAdmin),child: NowPlayingScreen2());
              //return NowPlayingScreen2();
            }

          else if (state is StateLoginWithSpotifyScreen){
            return  ChangeNotifierProvider(create: (context)=>LoginWithSpotifyViewModel(),child: LoginWithSpotifyScreen());
            //return BlocProvider(create: (BuildContext context)=>BlocLoginWithSpotifyScreen(),child: LoginWithSpotifyScreen(),);
          }
          else if (state is StateShowMyPartiesScreen){
            return BlocProvider(create: (BuildContext context)=>BlocShowMyPartiesScreen(), child: ShowMyPartiesScreen(),);
          }
          else if (state is StateShowCreatePartyScreen){
            return ChangeNotifierProvider(create: (context)=>CreatePartyViewModel(),child: CreatePartyScreen(),);
          }
           else if (state is StateJoinPartyScreen){
            return ChangeNotifierProvider(create: (context)=>JoinPartyViewModel(),child: JoinPartyScreen(),);
          }

          }
        )
      )
    );
  }
}

