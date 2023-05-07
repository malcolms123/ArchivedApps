

import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/screens/inner_wrapper/create_post/createPost.dart';
import 'package:friendscape/screens/inner_wrapper/profile/profile.dart';
import 'package:friendscape/screens/inner_wrapper/testing/test.dart';
import 'package:friendscape/services/authService.dart';
import 'explore/explore.dart';
import 'feed/feed.dart';

class InnerWrapper extends StatefulWidget {
  // initializing with user account
  final Account userAccount;
  InnerWrapper(this.userAccount);

  @override
  _InnerWrapperState createState() => _InnerWrapperState();
}

class _InnerWrapperState extends State<InnerWrapper> {

  /// SERVICES
  final AuthService authService = AuthService();

  /// STATE PROPERTIES
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
      /// APP BAR
      appBar: AppBar(
        title: appBarTitle(),
        backgroundColor: ThemeConstants.appBarColor,
        toolbarHeight: ThemeConstants.appBarHeight,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Logout'),
                value: 0,
              )
            ],
            onSelected: (value) async {
              if (value == 0) {
                await authService.signOut();
              }
            },
          )
        ],
      ),
      /// BODY
      body: bodyWidget(),
      /// BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Ratings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: ThemeConstants.navigationBarColor,
        unselectedItemColor: ThemeConstants.navigationBarUnselectedItemColor,
        selectedItemColor: ThemeConstants.navigationBarSelectedItemColor,
        currentIndex: index,
        onTap: (num) => setState(() => index = num),
      ),
    );
  }

  // logic for deciding correct body
  Widget bodyWidget() {
    switch(index) {
      case 0: return Feed(widget.userAccount);
      case 1: return Explore(widget.userAccount);
      case 2: return CreatePost(widget.userAccount);
      case 3: return Test();
      case 4: return Profile(widget.userAccount);
      default: {
        setState(() => index = 0);
        print('Index reached invalid value: ' + index.toString());
        return Text('oh no');
      }
    }
  }

  // logic for deciding correct app bar
  Widget appBarTitle() {
    switch(index) {
      case 0: return Text('Feed');
      case 1: return Text('Explore');
      case 2: return Text('Post');
      case 3: return Text('Ratings');
      case 4: return Text(widget.userAccount.username);
      default: {
        setState(() => index = 0);
        print('Index reached invalid value: ' + index.toString());
        return Text('oh no');
      }
    }
  }
}
