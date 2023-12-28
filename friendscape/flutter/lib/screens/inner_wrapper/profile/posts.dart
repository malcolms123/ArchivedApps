import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/screens/inner_wrapper/view_chat/viewChat.dart';
import 'package:provider/provider.dart';

class Posts extends StatelessWidget {
  // initializing with user account and rating pairs
  final Account userAccount;

  Posts(this.userAccount);

  @override
  Widget build(BuildContext context) {
    /// STREAMS
    List<Post> postsOut = Provider.of<List<Post>>(context);

    return Expanded(
      child: ListView(
          children: postsOut.map((post) {
        return ListTile(
            title: Text(post.posterUsername),
            subtitle: Text(post.postTime.toString()),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewChat(userAccount, post))));
      }).toList()),
    );
  }
}
