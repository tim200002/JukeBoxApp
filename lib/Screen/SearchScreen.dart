//! Here Bloc also isnt the right Design Pattern
//!User of View Model

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jukebox/ViewModel/SearchViewModel.dart';
import 'package:jukebox/Widgets/NowPlayingTile.dart';
import 'package:jukebox/Widgets/SearchTile.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  final String partyId;
  final String userId;
  SearchScreen({@required this.partyId, @required this.userId});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchViewModel(partyId: partyId, userId: userId), child: SearchScreenReal());
  }
}

class SearchScreenReal extends StatefulWidget {
  @override
  _SearchScreenRealState createState() => _SearchScreenRealState();
}

class _SearchScreenRealState extends State<SearchScreenReal> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
 SearchViewModel vm;

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with _searchQuery.text
      log("Text");
      vm.search(_searchQuery.text);
    });
  }

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
      
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     vm = Provider.of<SearchViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchQuery,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    hintText: "Search"),
              ),
              SizedBox(height: 10,),
               Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                    itemCount: vm.playlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SearchTile(vm: vm, song: vm.playlist[index]);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
