import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/ratings/allRatings.dart';
import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/screens/inner_wrapper/view_profile/viewProfile.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/firestore/accountService.dart';
import 'package:provider/provider.dart';

class PendingRatings extends StatelessWidget {
  // initializing with user account
  final Account userAccount;

  PendingRatings(this.userAccount);

  @override
  Widget build(BuildContext context) {
    /// STREAMS
    AllRatings allRatings = Provider.of<AllRatings>(context);

    // creating widget list
    List<Widget> widgetList = [Text('Pending Ratings')];
    widgetList.addAll(allRatings.pendingRatings
        .map((pendingRating) => PendingRatingTile(userAccount, pendingRating)));
    widgetList.add(Text('Unreturned Ratings'));
    widgetList.addAll(allRatings.unreturnedRatings.map((unreturnedRating) =>
        UnreturnedRatingTile(userAccount, unreturnedRating)));

    return Expanded(
      child: ListView(
        children: widgetList,
      ),
    );
  }
}

/// TILE FOR PENDING RATINGS
class PendingRatingTile extends StatelessWidget {
  // initializing with user account and pending rating
  final Rating pendingRating;
  final Account userAccount;

  PendingRatingTile(this.userAccount, this.pendingRating);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pendingRating.posterUsername),
      subtitle: Text(pendingRating.value.toString()),
      onTap: () async {
        AccountService accountService = AccountService();
        RequestResult result =
            await accountService.pullAccount(pendingRating.posterUid);
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

/// TILE FOR UNRETURNED RATINGS
class UnreturnedRatingTile extends StatelessWidget {
  // initializing with user account and unreturned rating
  final Account userAccount;
  final Rating unreturnedRating;

  UnreturnedRatingTile(this.userAccount, this.unreturnedRating);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(unreturnedRating.recipientUsername),
      subtitle: Text(unreturnedRating.value.toString()),
      onTap: () async {
        AccountService accountService = AccountService();
        RequestResult result =
            await accountService.pullAccount(unreturnedRating.recipientUid);
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
