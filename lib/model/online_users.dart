import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class OnlineUser{
  final String userId;
  final String online;
  final String updated;

  const OnlineUser({
    this.userId,
    this.online,
    this.updated
  });

  factory OnlineUser.fromDocument(DocumentSnapshot doc){
    return OnlineUser(
        userId: doc.documentID,
        online: doc['online'],
        updated: doc['updated']
    );
  }



}