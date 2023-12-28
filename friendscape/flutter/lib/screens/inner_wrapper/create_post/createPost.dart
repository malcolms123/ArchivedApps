import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/ratings/allRatings.dart';
import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/models/ratings/ratingPair.dart';
import 'package:friendscape/models/ratings/temporaryRatingCopies.dart';
import 'package:friendscape/models/recipient.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/firestore/postService.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  // initializing with user account
  final Account userAccount;

  CreatePost(this.userAccount);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  /// STATE PROPERTIES
  double minimumRating = 0;
  String body = '';

  @override
  Widget build(BuildContext context) {
    /// STREAMS
    List<RatingIn> ratingsIn1 = Provider.of<List<RatingIn>>(context);
    List<RatingOut> ratingsOut1 = Provider.of<List<RatingOut>>(context);

    List<Rating> ratingsIn = ratingsIn1.map((ratingIn) => Rating.fromRatingIn(ratingIn)).toList();
    List<Rating> ratingsOut = ratingsOut1.map((ratingOut) => Rating.fromRatingOut(ratingOut)).toList();

    List<RatingPair> ratingPairs = AllRatings(ratingsIn, ratingsOut).ratingPairs;

    return Column(
      children: [
        Row(
          children: [
            Slider(
              value: minimumRating,
              divisions: 5,
              min: 0,
              max: 5,
              onChanged: (value) => setState(() => minimumRating = value),
            ),
            Text(minimumRating.toString())
          ],
        ),
        TextField(
          decoration: InputDecoration(labelText: 'body'),
          onChanged: (s) => setState(() => body = s),
        ),
        TextButton(
          child: Text('submit'),
          onPressed: () async {
            PostService postService = PostService(widget.userAccount);
            List<Recipient> recipients = ratingPairs
                .where((ratingPair) => ratingPair.valueOut >= minimumRating)
                .map((ratingPair) =>
                    Recipient(ratingPair.ratedUid, ratingPair.ratedUsername))
                .toList();
            RequestResult result = await postService.postPost(
                Post(widget.userAccount, body), recipients);
            if (result.error) {
              AlertService.errorAlert(result.data, context);
            }
          },
        )
      ],
    );
  }
}
