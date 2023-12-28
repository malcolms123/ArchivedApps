import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/constants/firestoreConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/ratings/allRatings.dart';
import 'package:friendscape/models/ratings/rating.dart';
import 'package:friendscape/models/ratings/temporaryRatingCopies.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:rxdart/rxdart.dart';

class RatingsService {
  /// INFORMATION FOR REFERENCING DB
  final Account userAccount;
  late CollectionReference ratingsInCollection;
  late CollectionReference ratingsOutCollection;

  RatingsService(this.userAccount) {
    DocumentReference accountDoc = FirebaseFirestore.instance
        .collection(FirestoreConstants.accountsCollection)
        .doc(userAccount.uid);
    this.ratingsInCollection =
        accountDoc.collection(FirestoreConstants.ratingsInCollection);
    this.ratingsOutCollection =
        accountDoc.collection(FirestoreConstants.ratingsOutCollection);
  }

  /// POSTING TO FIRESTORE
  // post rating to ratings out collection
  // then handled by cloud function to post to recipient
  // possibly switch implementation to client side posting with security rules
  Future<RequestResult> postRating(Rating rating) async {
    try {
      await ratingsOutCollection.doc(rating.recipientUid).set(rating.format());
      return RequestResult(false, null);
    } catch (e) {
      return RequestResult(true, e.toString());
    }
  }

  /// STREAMS
  // stream of all ratings
  // keep in mind when handling ratings they will attempt to live update
  // because they are coming from a stream, stream is useful so they can
  // be accessed app wide while staying up to date implicitly
  Stream<AllRatings> get allRatings {
    Stream<List<Rating>> ratingsIn =
        ratingsInCollection.snapshots().map(ratingListFromSnapshot);
    Stream<List<Rating>> ratingsOut =
        ratingsOutCollection.snapshots().map(ratingListFromSnapshot);
    return CombineLatestStream.combine2(ratingsIn, ratingsOut,
        (rIn, rOut) => AllRatings(rIn as List<Rating>, rOut as List<Rating>));
  }

  // functions for mapping rating streams into custom objects
  List<Rating> ratingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Rating.fromDoc(doc)).toList();
  }

  /// TEMPORARY STREAMS TO WORK AROUND ALLRATINGS BUG
  Stream<List<RatingIn>> get ratingsIn {
    return ratingsInCollection.snapshots().map(ratingInListFromSnapshot);
  }

  List<RatingIn> ratingInListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => RatingIn.fromDoc(doc)).toList();
  }

  Stream<List<RatingOut>> get ratingsOut {
    return ratingsOutCollection.snapshots().map(ratingOutListFromSnapshot);
  }

  List<RatingOut> ratingOutListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => RatingOut.fromDoc(doc)).toList();
  }
}
