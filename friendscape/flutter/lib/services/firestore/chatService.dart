import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/constants/firestoreConstants.dart';
import 'package:friendscape/models/chat.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/requestResult.dart';

class ChatService {

  final Post post;
  late CollectionReference chatsCollection;

  ChatService(this.post) {
    this.chatsCollection = FirebaseFirestore.instance.collection(
        FirestoreConstants.postsCollection).doc(post.postUid).collection(
        FirestoreConstants.chatsCollection);
  }


  Future<RequestResult> postChat(Chat chat) async {
    try {
      await chatsCollection.doc(chat.chatUid).set(chat.format());
      return RequestResult(false, null);
    } catch(e) {
      return RequestResult(true, e.toString());
    }
  }


  Stream<List<Chat>> get chats {
    return chatsCollection.snapshots().map(chatListFromSnapshot);
  }

  List<Chat> chatListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) =>Chat.fromDoc(doc)).toList();
  }
}