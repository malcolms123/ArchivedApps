import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/screens/inner_wrapper/view_chat/viewChat.dart';
import 'package:friendscape/services/firestore/postService.dart';

class Feed extends StatelessWidget {
  final Account userAccount;

  Feed(this.userAccount);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosts(),
        builder: (BuildContext context, AsyncSnapshot<RequestResult> snapshot) {
          if (snapshot.hasData) {
            RequestResult result = snapshot.data!;
            if (result.error) {
              return Text(result.data);
            } else {
              List<Post> posts = result.data;
              return ListView(
                  children: posts.map((post) {
                return ListTile(
                    title: Text(post.posterUsername),
                    subtitle: Text(post.postTime.toString()),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewChat(userAccount, post))));
              }).toList());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<RequestResult> getPosts() async {
    PostService postService = PostService(userAccount);
    return postService.pullPosts();
  }
}
