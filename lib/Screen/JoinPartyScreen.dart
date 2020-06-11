import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/ViewModel/JoinPartyViewModel.dart';
import 'package:provider/provider.dart';

class JoinPartyScreen extends StatelessWidget {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    JoinPartyViewModel vm = Provider.of<JoinPartyViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    BlocProvider.of<NavigationBloc>(context)
                        .add(NavigateToWelcomeScreen());
                  },
                ),
                Text(
                  "Join a Party",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
             TextField(
              controller: textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: "Join a Party"),
            ),
            if (vm.validationFailed) Text("Creating the Party failed try again or go back", style: TextStyle(color: Colors.red),) ,
            Spacer(),
            //Button
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.black, width: 3)),
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.white,
                  child: Builder(
                    builder: (context) {
                      if (vm.isValidating)
                        return CircularProgressIndicator();
                      else
                        return Text(
                          "Join a Party",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        );
                    },
                  ),
                  onPressed: () {
                    vm.validate(textController.text).then((party) => BlocProvider.of<NavigationBloc>(context).add(NavigateToNowPlayingScreen(isAdmin: false, partyId: party["partyId"],partyName: party["partyName"] )));
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
