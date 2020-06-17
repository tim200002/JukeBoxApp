import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jukebox/ViewModel/NowPlayingScreenViewModell.dart';
import 'package:jukebox/models/song.dart';

class NowPlayingTile extends StatefulWidget {
  NowPlayingigViewModel vm;
  final Song song;
  final bool canVote;

  NowPlayingTile({@required this.vm, @required this.song, @required this.canVote});
  @override
  _NowPlayingTileState createState() => _NowPlayingTileState();
}

class _NowPlayingTileState extends State<NowPlayingTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  widget.song.albumArt,
                  height: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                                  child: Column(
                    children: <Widget>[
                       Text(widget.song.title,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                      Text(widget.song.artist),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                Opacity(
                  opacity: widget.canVote?1.0:0.3,
                  child: Image.asset(
                    'lib/Assets/heart.png',
                    height: 35,
                  ),
                )
                
              ],
            ),
          ),
        ),
        onTap: () {
          if(widget.canVote){ widget.vm.vote(widget.song);}
          else log("You already voted");
         
        });
  }
}
