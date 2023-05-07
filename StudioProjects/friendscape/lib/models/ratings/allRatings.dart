import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/models/ratings/ratingPair.dart';

class AllRatings {
  /// NOTES
  // only used locally

  // properties
  late List<RatingPair> ratingPairs;
  late List<Rating> pendingRatings;
  late List<Rating> unreturnedRatings;

  AllRatings(List<Rating> ratingsIn, List<Rating> ratingsOut) {
    this.ratingPairs = [];
    /// TEMPORARY PRINT STATEMENTS FOR DEBUGGING
    /// FIX THIS SHIT
    //print('ratingsIn: ' + ratingsIn.map((r) => r.posterUsername).toString());
    //print('ratingsOut: ' + ratingsOut.map((r) => r.recipientUsername).toString());
    // checking all ratings out for matching rating in
    ratingsOut.forEach((ratingOut) {
      List<Rating> returnedRating = ratingsIn
          .where((ratingIn) => ratingIn.posterUid == ratingOut.recipientUid)
          .toList();
      if (returnedRating.isNotEmpty) {
        this.ratingPairs.add(RatingPair(returnedRating[0], ratingOut));
      }
    });
    // clearing matched ratings
    this.ratingPairs.forEach((ratingPair) {
      ratingsIn
          .removeWhere((rating) => rating.posterUid == ratingPair.ratedUid);
      ratingsOut.removeWhere(
          (rating) => rating.recipientUid == ratingPair.ratedUid);
    });
    // storing unmatched ratings
    this.pendingRatings = ratingsIn;
    this.unreturnedRatings = ratingsOut;
  }
}
