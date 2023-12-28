import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/chat.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/firestore/chatService.dart';

class ViewChat extends StatefulWidget {
  // initializing with user account and post that hosts chat
  final Account userAccount;
  final Post post;

  ViewChat(this.userAccount, this.post);

  @override
  _ViewChatState createState() => _ViewChatState();
}

class _ViewChatState extends State<ViewChat> {
  /// STATE PROPERTIES
  String reply = '';

  @override
  Widget build(BuildContext context) {
    ChatService chatService = ChatService(widget.post);
    return StreamBuilder(
      stream: chatService.chats,
      builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
        // sorting the chats by post time
        if (snapshot.hasData) {
          List<Chat> chats = snapshot.data!;
          chats..sort((a, b) => a.postTime.compareTo(b.postTime));

          return Scaffold(
            backgroundColor: ThemeConstants.backgroundColor,
            appBar: AppBar(
              backgroundColor: ThemeConstants.appBarColor,
              toolbarHeight: ThemeConstants.appBarHeight,
              title: Text(widget.post.body),
            ),
            body: Column(
              children: [
                // creating new chat
                TextField(
                  decoration: InputDecoration(labelText: 'Reply to post'),
                  onChanged: (s) => setState(() => reply = s),
                ),
                TextButton(
                  child: Text('submit reply'),
                  onPressed: () async {
                    Chat chat = Chat(widget.userAccount, reply);
                    RequestResult result = await chatService.postChat(chat);
                    if (result.error) {
                      AlertService.errorAlert(result.data, context);
                    }
                  },
                ),
                // viewing old chats
                Expanded(
                    child: ListView(
                        children: chats
                            .map((chat) => ListTile(
                                  title: Text(chat.body),
                                  subtitle: Text(chat.posterUsername),
                                ))
                            .toList()))
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
