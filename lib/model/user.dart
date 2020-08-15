import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class User{
  final String userId;
  final String username;
  final String email;
  final String phone;
  final String authority;// - admin, manager, user
  final String photoUrl;
  final String created;
  final String updated;

  const User({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.authority,
    this.photoUrl,
    this.created,
    this.updated
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
      userId: doc.documentID,
      username: doc['username'],
      email: doc['email'],
      phone: doc['phone'],
      authority: doc['authority'],
      photoUrl: doc['photoUrl'],
      created: doc['created'],
      updated: doc['updated']
    );
  }



}