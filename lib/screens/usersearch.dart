import 'package:flutter/material.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/profile.dart';
import 'package:insta/services/database/user_database.dart';

class UserSearch extends SearchDelegate {
  UserDatabaseService _databaseService = UserDatabaseService();

  final List<UserProfileWithUid> _list;
  int ind = 0;
  UserSearch(this._list);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Profile(_list[ind].uid);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    List<String> searchElements = [];

    for(int i =0;i<_list.length;i++)
      {
        searchElements.add(_list[i].name);
      }

    final List<UserProfileWithUid> suggestionlist =
        query.isEmpty ? _list :_list;

    return ListView.builder(
      itemCount: suggestionlist.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          suggestionlist[index].name,
        ),
        onTap: () {
          ind = index;
          showResults(context);
        },
        leading: CircleAvatar(
          backgroundImage: NetworkImage(suggestionlist[index].dpurl),
        ),
      ),
    );
  }
}
