import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/main.dart';
import 'package:flutter_companybook/service/services.dart';
import 'package:flutter_companybook/widgets/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_companybook/config/constants.dart';

import '../config/palette.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: Text(
              'AmFine Ltd.',
              style: const TextStyle(
                color: Palette.facebookBlue,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.2,
                fontFamily: "WhiteCat"
              ),
            ),
            centerTitle: false,
            floating: true,
            actions: [
              CircleButton(
                icon: Icons.search,
                iconSize: 30.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchUser()),
                  );
                }
              ),
              CircleButton(
                icon: Icons.close,
                iconSize: 30.0,
                onPressed: logoutUser,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: CreatePostContainer(),
          ),

        ],
      ),
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async{
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Constants.preferences = null;

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyApp()), (Route<dynamic> route) => false);

  }

}

