import 'package:bakaiti_app/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_chat.dart';

class APIs {
  //for Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing cloud firestore.
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //to return current users.
  static get user {
    return auth.currentUser!;
  }

  //for checking if the user is exist or not.
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = UserChat(
      image: user.photoURL.toString(),
      about: "Hey Im using bakaiti",
      name: user.displayName.toString(),
      createdAt: time,
      id: user.uid,
      lastActive: time,
      isOnline: false,
      email: user.email.toString(),
      pushToken: '',
    );

    return (await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatuser.toJson()));
  }

  //For getting all the users.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //Object to store the data of the login User.
  static late UserChat loggined_user;

  //For getting login user info to show in profile.
  static Future<void> getLoginUserInfo() async {
    await firestore.collection('users').doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          loggined_user = UserChat.fromJson(user.data()!);
        } else {
          await createUser().then(
            (value) => getLoginUserInfo(),
          );
        }
      },
    );
  }

  //To Store Upadted Value of Profile Screen by user.
  static Future<void> storeUpdatedDataOfProfile() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': loggined_user.name,
      'about': loggined_user.about,
    });
  }

  //************************APIs Related to Chat Screen***************/

  //for getting Conversation id.
  static gettingConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //For getting all messages of Specific conversation.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserChat user) {
    return firestore
        .collection(
            'chats/${gettingConversationId(user.id.toString())}/messages/')
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessages(UserChat userChat, String msg) async {
    //message sending time (also used as a Id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Messages message = Messages(
        fromID: user.uid,
        msg: msg,
        msgType: '${Type.text}',
        readTime: '',
        sentTime: time,
        toID: userChat.id);

    final ref = firestore.collection(
        'chats/${gettingConversationId(userChat.id.toString())}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  //to show the message read status.
  static Future<void> getupdatedMessageReadStatus(Messages message) async {
    firestore
        .collection(
            'chats/${gettingConversationId(message.fromID.toString())}/messages/')
        .doc(message.sentTime)
        .update({'readTime': DateTime.now().microsecondsSinceEpoch.toString()});
  }
}
