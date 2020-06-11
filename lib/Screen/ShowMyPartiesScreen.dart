import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/BlocShowMyPartiesScreen.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/Event/EventsShowMyPartiesScreen.dart';
import 'package:jukebox/State/StateShowMyPartiesScreen.dart';
import 'package:jukebox/models/party.dart';

class ShowMyPartiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocShowMyPartiesScreen, ShowMyPartiesScreenStates>(
      builder: (context, state) {
        if (state is Loading) {
          BlocProvider.of<BlocShowMyPartiesScreen>(context)
              .add(EventLoadParties());
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PartiesLoaded) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "My Parties: ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.parties.length,
                      itemBuilder: (BuildContext context, int index) {
                        Party party=  state.parties[index];
                        return MaterialButton(
                          child:Row(children: <Widget>[ Text(party.partyName), Text("is Admin: "+ party.isAdmin.toString())],mainAxisAlignment: MainAxisAlignment.spaceBetween,),
                          onPressed: (){
                            BlocProvider.of<NavigationBloc>(context).add(NavigateToNowPlayingScreen(isAdmin: party.isAdmin, partyId: party.partyId, partyName: party.partyName));
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
