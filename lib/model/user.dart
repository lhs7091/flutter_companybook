import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class UserModel{
  final String userId;
  final String username;
  final String email;
  final String phone;
  final String authority;// - admin, manager, user
  final String photoUrl;
  final String created;
  final String updated;

  const UserModel({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.authority,
    this.photoUrl,
    this.created,
    this.updated
  });

  factory UserModel.fromDocument(DocumentSnapshot doc){
    return UserModel(
      userId: doc.get('userId'),
      username: doc.get('userName'),
      email: doc.get('email'),
      authority: doc.get('authority'),
      photoUrl: doc.get('photoUrl'),
      created: doc.get('created'),
      updated: doc.get('updated')
    );
  }



}