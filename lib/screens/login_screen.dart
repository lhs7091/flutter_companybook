import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/screens/screens.dart';
import 'package:flutter_companybook/service/auth.dart';
import 'package:flutter_companybook/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  User currentUser;

  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  isSignedIn() async {
    this.setState(() {
      isLoggedIn = true;
    });
    preferences = await SharedPreferences.getInstance();
    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    this.setState(() {
      isLoading = false;
    });
  }

  login() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      preferences = await SharedPreferences.getInstance();
      authMethods.signInWithUsernameAndEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text)
          .then((value) {
        //print("${value.uid}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });

      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.lightBlueAccent, Colors.purpleAccent]
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Company workspace",
                style: TextStyle(fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: "WhiteCat"),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailTextEditingController,
                      style: simpleTextFieldStyle(),
                      decoration: InputDecoration(
                        hintText: "EMAIL",
                        hintStyle: simpleTextFieldStyle(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      style: simpleTextFieldStyle(),
                      decoration: InputDecoration(
                        hintText: "PASSWORD",
                        hintStyle: simpleTextFieldStyle(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: () {

                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Forgot Password?",
                      style: mediumTextFieldStyle(),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0,),
              GestureDetector(
                onTap: controlSignInFirebase,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(vertical: 20.0,),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff0027EF4),
                          const Color(0xff2A75BC)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Text(
                    "LogIn",
                    style: simpleTextFieldStyle(),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: controlSignInGoogle,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(vertical: 20.0,),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Column(
                    children: [
                      Text(
                        "LogIn with Google",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: isLoading ? circularProgress() : Container(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account?",
                    style: mediumTextFieldStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> controlSignInGoogle() async {
    preferences = await SharedPreferences.getInstance();
    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuthentication = await googleUser
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken);

    final UserCredential authResult = await firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    // Signin Success
    if (user != null) {
      //check if already signup
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance.collection(
          "users").where("userId", isEqualTo: user.uid).get();

      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      // Save Data to firestore if new user
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance.collection("users")
            .doc(user.uid)
            .set({
          "userName": user.displayName,
          "photoUrl": user.photoURL,
          "userId": user.uid,
          "aboutMe": "i am using Company workspace",
          "created": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "updated": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "chattingWith": null,
          "email": user.email,
          "authority": "1"
        });

        //Write data to Local
        currentUser = user;
        await preferences.setString("userId", currentUser.uid);
        await preferences.setString("userName", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
        await preferences.setString("aboutMe", Constants.ABOUT_ME_INIT);
        await preferences.setString("chattingWith", null);
        await preferences.setString("email", currentUser.email);
        await preferences.setString("authority", Constants.AUTHORITY_GENERAL);
        await preferences.setString("googleUser", "1");
      } else {
        //Write data to Local
        currentUser = user;
        await preferences.setString("userId", documentSnapshots[0].get("userId"));
        await preferences.setString(
            "userName", documentSnapshots[0].get("userName"));
        await preferences.setString(
            "photoUrl", documentSnapshots[0].get("photoUrl"));
        await preferences.setString("aboutMe", documentSnapshots[0].get("aboutMe"));
        await preferences.setString(
            "chttingWith", documentSnapshots[0].get("chattingWith"));
        await preferences.setString("email", documentSnapshots[0].get("email"));
        await preferences.setString(
            "authority", documentSnapshots[0].get("authority"));
        await preferences.setString("googleUser", "1");
      }

      Fluttertoast.showToast(msg: "Sign in Success!");
      this.setState(() {
        isLoading = false;
      });

      Constants.preferences = preferences;
      Constants.firebaseUser = currentUser;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // Signin Fail
    } else {
      Fluttertoast.showToast(msg: "Try Again, Sign in Failed");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> controlSignInFirebase() async {
    preferences = await SharedPreferences.getInstance();
    UserCredential authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailTextEditingController.text, password: passwordTextEditingController.text);
    User user = authResult.user;


    // Signin Success
    if (user != null) {
      //check if already signup
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance.collection("users").where("userId", isEqualTo: user.uid).get();
      List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      // Save Data to firestore if new user
      if (documentSnapshots.length == 0) {
        FirebaseFirestore.instance.collection("users")
            .doc(user.uid)
            .set({
          "userName": user.displayName,
          "photoUrl": Constants.DEFAULT_IMAGE,
          "userId": user.uid,
          "aboutMe": "i am using Company workspace",
          "created": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "updated": DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          "chattingWith": null,
          "email": user.email,
          "authority": "1"
        });

        //Write data to Local
        currentUser = user;
        await preferences.setString("userId", currentUser.uid);
        await preferences.setString("userName", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoURL);
        await preferences.setString("aboutMe", Constants.ABOUT_ME_INIT);
        await preferences.setString("chattingWith", null);
        await preferences.setString("email", currentUser.email);
        await preferences.setString("authority", Constants.AUTHORITY_GENERAL);
        await preferences.setString("googleUser", "0");
      } else {
        //Write data to Local
        currentUser = user;

        await preferences.setString("userId", documentSnapshots[0].get("userId"));
        await preferences.setString(
            "userName", documentSnapshots[0].get("userName"));
        await preferences.setString(
            "photoUrl", documentSnapshots[0].get("photoUrl"));
        await preferences.setString("aboutMe", documentSnapshots[0].get("aboutMe"));
        await preferences.setString(
            "chttingWith", documentSnapshots[0].get("chattingWith"));
        await preferences.setString("email", documentSnapshots[0].get("email"));
        await preferences.setString(
            "authority", documentSnapshots[0].get("authority"));
        await preferences.setString("googleUser", "0");
      }

      Fluttertoast.showToast(msg: "Sign in Success!");
      this.setState(() {
        isLoading = false;
      });

      Constants.preferences = preferences;
      Constants.firebaseUser = currentUser;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      // Signin Fail
    } else {
      Fluttertoast.showToast(msg: "Try Again, Sign in Failed");
      this.setState(() {
        isLoading = false;
      });
    }

  }
}

