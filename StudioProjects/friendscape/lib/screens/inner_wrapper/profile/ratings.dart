import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/ratings/allRatings.dart';
import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/models/ratings/ratingPair.dart';
import 'package:friendscape/models/ratings/temporaryRatingCopies.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/screens/inner_wrapper/view_profile/viewProfile.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/firestore/accountService.dart';
import 'package:provider/provider.dart';

class Ratings extends StatelessWidget {
  // initializing with user account
  final Account userAccount;

  Ratings(this.userAccount);

  @override
  Widget build(BuildContext context) {
    /// STREAMS
    //AllRatings allRatings = Provider.of<AllRatings>(context);
    List<RatingIn> ratingsIn = Provider.of<List<RatingIn>>(context);
    List<RatingOut> ratingsOut = Provider.of<List<RatingOut>>(context);
    /// PRINT STATEMENTS FOR DEBUGGING
    //print(ratingsIn.map((e) => e.posterUsername));
    //print(ratingsOut.map((e) => e.recipientUsername));
    List<RatingPair> ratingPairs = AllRatings(
            ratingsIn.map((ratingIn) => Rating.fromRatingIn(ratingIn)).toList(),
            ratingsOut
                .map((ratingOut) => Rating.fromRatingOut(ratingOut))
                .toList())
        .ratingPairs;

    return Expanded(
      child: ListView(
          children: ratingPairs
              .map((ratingPair) => RatingPairTile(userAccount, ratingPair))
              .toList()),
    );
  }
}

/// LIST TILE WIDGET
class RatingPairTile extends StatelessWidget {
  final Account userAccount;
  final RatingPair ratingPair;

  RatingPairTile(this.userAccount, this.ratingPair);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ratingPair.ratedUsername),
      subtitle: Text('to/from = ' +
          ratingPair.valueOut.toString() +
          '/' +
          ratingPair.valueIn.toString()),
      onTap: () async {
        AccountService accountService = AccountService();
        RequestResult result =
            await accountService.pullAccount(ratingPair.ratedUid);
        if (result.error) {
          AlertService.errorAlert(result.data, context);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewProfile(userAccount, result.data)));
        }
      },
    );
  }
}
