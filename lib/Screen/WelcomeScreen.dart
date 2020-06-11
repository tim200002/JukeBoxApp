import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/BlocWelcomeScreen.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/Event/EventsWelcomeScreen.dart';
import 'package:jukebox/State/StatesWelcomeScreen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BlocWelcomeScreen _blocWelcomeScreen =
        BlocProvider.of<BlocWelcomeScreen>(context); //Just for easier acces
    return BlocBuilder<BlocWelcomeScreen, WelcomeScreenStates>(
      builder: (context, state) {
        if (state is Initializing) {
          _blocWelcomeScreen.add(EventInitialise());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        //Initialised
        else if (state is Initialised) {
          return Scaffold(
              body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Image.asset(
                    'lib/Assets/jukebox.png',
                    height: 200,
                  ),
                  Spacer(),
                  //First Button
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minWidth: double.infinity,
                      height: 50,
                      color: Colors.black,
                      child: Text(
                        "Create a Party",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add((CreateParty()));
                      },
                    ),
                  ),

                  //Second Button
                    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minWidth: double.infinity,
                      height: 50,
                      color: Colors.grey,
                      child: Text(
                        "Show my Parties",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                        BlocProvider.of<NavigationBloc>(context).add(NavigateToShowMyPartiesScreen());
                      },
                    ),
                  ),
                  //Third Button            
                    Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color:Colors.black, width:3)
                        ),
                      minWidth: double.infinity,
                      height: 50,
                      color: Colors.white,
                      child: Text(
                        "Join a Party",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      onPressed: () {
                         BlocProvider.of<NavigationBloc>(context).add(NavigateToJoinPartyScreen());
                      },
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ));
        }
      },
    );
  }
}
