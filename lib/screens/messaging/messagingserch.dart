import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/messaging/chat_screen.dart';
import 'package:provider/provider.dart';

class MessageSearch extends SearchDelegate {
  List<UserProfileWithUid> suggestionlist;

  final List<UserProfileWithUid> _list;
  int ind = 0;
  MessageSearch(this._list);

  List<UserProfileWithUid> suggestion(String q) {
    List<UserProfileWithUid> ans = [];
    for (int i = 0; i < _list.length; i++) {
      if (_list[i].name.toLowerCase().startsWith(q.toLowerCase())) {
        ans.add(_list[i]);
      }
    }
    return ans;
  }

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
  // ignore: missing_return
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResu
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    bool dark = Provider.of<bool>(context);
    final user = Provider.of<UserDetails>(context);

    List<String> searchElements = [];

    for (int i = 0; i < _list.length; i++) {
      searchElements.add(_list[i].name);
    }

    suggestionlist = query.isEmpty ? _list : suggestion(query);

    return Container(
      color: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
      child: ListView.builder(
        itemCount: suggestionlist.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            suggestionlist[index].name,
            style: TextStyle(color: dark ? Colors.white : Colors.black),
          ),
          onTap: () async {
            ind = index;
//          showResults(context);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          uid: suggestionlist[index].uid,
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(suggestionlist[index].dpurl),
          ),
        ),
      ),
    );
  }
}
