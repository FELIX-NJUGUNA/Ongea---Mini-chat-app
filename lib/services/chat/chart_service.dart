import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ongea_chat_app/models/message.dart';

class ChartService {
  // firestore instance and auth instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go thru each individual user
        final user = doc.data();
        // return user
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chart room id for two users (sorted to ensure na uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort ids === ensures that the chartroomID is same for any 2 people
    String chartRoomID = ids.join('_');
    // add new message to DB
    await _firestore
        .collection("chart_rooms")
        .doc(chartRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      String userID, otherUserID) {
    // construct a chartroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chartRoomID = ids.join('_');

    return _firestore
        .collection("chart_rooms")
        .doc(chartRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
