import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jukebox/Bloc/navigationBloc.dart';
import 'package:jukebox/ViewModel/CreatePartyViewModel.dart';
import 'package:provider/provider.dart';

class CreatePartyScreen extends StatelessWidget {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    CreatePartyViewModel vm = Provider.of<CreatePartyViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Create Party",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)),
                  hintText: "Create Party"),
            ),
             if (vm.validationFailed) Text("Creating the Party failed try again or go back", style: TextStyle(color: Colors.red),) ,
            Spacer(),
            //Button To Create Party
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
                        "Create a Party",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      );
                  },
                ),
                onPressed: () {
                  vm.validate(textController.text).then((party) => BlocProvider.of<NavigationBloc>(context).add(NavigateToNowPlayingScreen(isAdmin: true, partyId: party["partyId"],partyName: party["partyName"] )));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
