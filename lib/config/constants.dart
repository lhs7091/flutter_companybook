import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants{
  static User firebaseUser;
  static SharedPreferences preferences;

  static final String AUTHORITY_GENERAL = "1";
  static final String AUTHORITY_MANAGER = "2";
  static final String AUTHORITY_ADMIN = "3";

  static final String ABOUT_ME_INIT = "I am using workspace";
  static final String DEFAULT_IMAGE = "https://firebasestorage.googleapis.com/v0/b/companybooktutorial.appspot.com/o/default.png?alt=media&token=9c189e0c-4be1-4b6b-aa13-b91834f430fc";

  static final String USERNAME = "userName";
  static final String PHOTOURL = "photoUrl";
  static final String USERID = "userId";
  static final String ABOUTME = "aboutMe";
  static final String CREATED = "created";
  static final String UPDATED = "updated";
  static final String CHATTINGWITH = "chattingWith";
  static final String EMAIL = "email";
  static final String AUTHORITY = "authority";

}

