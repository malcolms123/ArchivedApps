import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/ratings/allRatings.dart';
import 'package:friendscape/models/ratings/temporaryRatingCopies.dart';
import 'package:friendscape/screens/auth_wrapper/authWrapper.dart';
import 'package:friendscape/services/firestore/postService.dart';
import 'package:friendscape/services/firestore/ratingsService.dart';
import 'package:provider/provider.dart';

import 'inner_wrapper/innerWrapper.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// STREAMS
    User? user = Provider.of<User?>(context);

    if (user == null || user.displayName == null) {
      return AuthWrapper();
    } else {
      // null safety here should be fine bc of if statement
      Account userAccount = Account(user, user.displayName!);
      RatingsService ratingsService = RatingsService(userAccount);
      PostService postService = PostService(userAccount);
      return MultiProvider(providers: [
        /// THIS STREAM IS FUCKING BROKEN
        StreamProvider<AllRatings>.value(
          value: ratingsService.allRatings,
          initialData: AllRatings([], []),
        ),
        StreamProvider<List<Post>>.value(
          value: postService.postsOut,
          initialData: [],
        ),

        /// TEMPORARY STREAMS FOR BUG WORKAROUND
        StreamProvider<List<RatingIn>>.value(
          value: ratingsService.ratingsIn,
          initialData: [],
        ),
        StreamProvider<List<RatingOut>>.value(
          value: ratingsService.ratingsOut,
          initialData: [],
        ),
      ], child: InnerWrapper(userAccount));
    }
  }
}
