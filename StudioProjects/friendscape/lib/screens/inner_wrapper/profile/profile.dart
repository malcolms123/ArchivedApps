import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/screens/inner_wrapper/profile/pendingRatings.dart';
import 'package:friendscape/screens/inner_wrapper/profile/posts.dart';
import 'package:friendscape/screens/inner_wrapper/profile/ratings.dart';

class Profile extends StatefulWidget {
  // initializing with user account
  final Account userAccount;

  Profile(this.userAccount);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  /// STATE PROPERTIES
  int index = 0;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Image(image: AssetImage('assets/defaultProfilePicture.jpeg')),
        Row(
          children: [
            TextButton(
                child: Text('Posts'),
                onPressed: () => setState(() => index = 0)),
            TextButton(
                child: Text('Ratings'),
                onPressed: () => setState(() => index = 1)),
            TextButton(
                child: Text('Pending Ratings'),
                onPressed: () => setState(() => index = 2))
          ],
        ),
        body()
      ],
    );
  }

  Widget body() {
    if (index == 1) {
      return Ratings(widget.userAccount);
    } else if (index == 2) {
      return PendingRatings(widget.userAccount);
    } else {
      return Posts(widget.userAccount);
    }
  }
}
