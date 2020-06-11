import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:jukebox/Bloc/BlocLoginWithSpotify.dart';
import 'package:jukebox/Event/EventsLoginWithSpotifyScreen.dart';
import 'package:jukebox/State/StateLoginWithSpotifyScreen.dart';
import 'package:jukebox/ViewModel/LoginWithSpotifyViewModel.dart';
import 'package:jukebox/ViewModel/NowPlayingScreenViewModell.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWithSpotifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LoginWithSpotifyViewModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset(
                    "lib/Assets/jukebox.png",
                    width: 200,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Login With Spotify",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "To Create a Party you must\nconnect to your spotify Premium \nAccount",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Spacer(),

              //Not connected -> connect Button
              if (vm.isConnected == false)
                //Button
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: double.infinity,
                    height: 50,
                    color: Colors.lightGreenAccent[400],
                    child: Text(
                      "Connect with Spotify",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () async {
                      var url = await vm.getUrl();
                      log("my url");
                      final flutterWebviewPlugin = new FlutterWebviewPlugin();
                      flutterWebviewPlugin.onUrlChanged.listen((String url) {
                        log("Opened url: " + url);
                        if (url
                            .contains("http://192.168.0.250:8080/callback")) {
                          flutterWebviewPlugin.close();
                          Navigator.pop(context);
                        }
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => 
                            WebviewScaffold(
                                url: url,
                                appBar: AppBar(
                                  backgroundColor: Colors.white,
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          flutterWebviewPlugin.close();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"))
                                  ],
                                ),
                              ),
                          )).then((value) {
                            vm.validate(); //Whe come Back check       
                      });
                    },
                  ),
                ),

              //Connected -> Grey Button
              if (vm.isConnected == true)
                //Button
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    minWidth: double.infinity,
                    height: 50,
                    color: Colors.grey,
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      log("Pressed");
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
