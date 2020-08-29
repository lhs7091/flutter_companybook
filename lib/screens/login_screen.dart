import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/screens/home_screen.dart';
import 'package:flutter_companybook/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_companybook/config/constants.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key key}):super(key:key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences preferences;
  bool isLoggedIn = false;
  bool isLoading = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();

    isSignedIn();
  }

  isSignedIn() async{
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if(isLoggedIn){
      //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.lightBlueAccent, Colors.purpleAccent]
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Company workspace clone",
              style: TextStyle(fontSize: 50.0, color: Colors.white, fontFamily: "WhiteCat"),
            ),
            GestureDetector(
              onTap: controlSignIn,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 270.0,
                      height: 65.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/google_signin_button.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:EdgeInsets.all(1.0),
                      child: isLoading ? circularProgress() : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> controlSignIn() async{

    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuthentication.idToken, accessToken: googleAuthentication.accessToken);

    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

    // Signin Success
    if(firebaseUser != null){

      //check if already signup
      final QuerySnapshot resultQuery = await Firestore.instance.collection("users").where("id", isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.documents;

      // Save Data to firestore if new user
      if(documentSnapshots.length == 0){
        Firestore.instance.collection("users").document(firebaseUser.uid).setData({
          "userName" : firebaseUser.displayName,
          "photoUrl" : firebaseUser.photoUrl,
          "userId" : firebaseUser.uid,
          "aboutMe" : "i am using Company workspace",
          "created" : DateTime.now().millisecondsSinceEpoch.toString(),
          "updated" : DateTime.now().millisecondsSinceEpoch.toString(),
          "chattingwith" : null,
          "email": firebaseUser.email,
          "authority": "1"
        });

        //Write data to Local
        currentUser = firebaseUser;
        await preferences.setString("userId", currentUser.uid);
        await preferences.setString("userName", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        await preferences.setString("aboutMe", Constants.ABOUT_ME_INIT);
        await preferences.setString("chattingWith", null);
        await preferences.setString("email", currentUser.email);
        await preferences.setString("authority", Constants.AUTHORITY_GENERAL);
      }else{
        //Write data to Local
        currentUser = firebaseUser;
        await preferences.setString("userId", documentSnapshots[0]["id"]);
        await preferences.setString("userName", documentSnapshots[0]["userName"]);
        await preferences.setString("photoUrl", documentSnapshots[0]["photoUrl"]);
        await preferences.setString("aboutMe", documentSnapshots[0]["aboutMe"]);
        await preferences.setString("chttingWith", documentSnapshots[0]["chattingWith"]);
        await preferences.setString("email", documentSnapshots[0]["email"]);
        await preferences.setString("authority", documentSnapshots[0]["authority"]);

      }

      Fluttertoast.showToast(msg: "Sign in Success!");
      this.setState(() {
        isLoading = false;
      });

      Constants.preferences = preferences;
      Constants.firebaseUser = currentUser;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    // Signin Fail
    }else{
      Fluttertoast.showToast(msg: "Try Again, Sign in Failed");
      this.setState(() {
        isLoading = false;
      });
    }
  }

}

