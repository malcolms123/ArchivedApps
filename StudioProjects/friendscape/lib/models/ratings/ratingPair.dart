import 'package:friendscape/models/ratings/rating.dart';

class RatingPair {

  /// NOTES
  // only used locally

  late String userUid;
  late String userUsername;
  late String ratedUid;
  late String ratedUsername;
  late double valueIn;
  late double valueOut;

  RatingPair(Rating ratingIn, Rating ratingOut) {
    this.userUid = ratingOut.posterUid;
    this.userUsername = ratingOut.posterUsername;
    this.ratedUid = ratingOut.recipientUid;
    this.ratedUsername = ratingOut.recipientUsername;
    this.valueIn = ratingIn.value;
    this.valueOut = ratingOut.value;
  }
}