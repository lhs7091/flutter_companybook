import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  createChatRoom(String chatRoomid, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomid)
        .setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

}