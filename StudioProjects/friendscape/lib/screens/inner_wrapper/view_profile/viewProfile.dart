import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/services/firestore/ratingsService.dart';

class ViewProfile extends StatefulWidget {
  // initializing with user account and view account
  final Account userAccount;
  final Account viewAccount;

  ViewProfile(this.userAccount, this.viewAccount);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  /// STATE PROPERTIES
  double ratingValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeConstants.appBarColor,
        toolbarHeight: ThemeConstants.appBarHeight,
        title: Text(widget.viewAccount.username),
      ),
      body: ListView(children: [
        Row(children: [
          Slider(
            value: ratingValue,
            divisions: 4,
            min: 1,
            max: 5,
            onChanged: (value) => setState(() => ratingValue = value),
          ),
          Text(ratingValue.toString()),
          TextButton(
            child: Text('Submit'),
            onPressed: () async {
              RatingsService ratingService = RatingsService(widget.userAccount);
              ratingService.postRating(
                  Rating(widget.userAccount, widget.viewAccount, ratingValue));
            },
          )
        ])
      ]),
    );
  }
}
