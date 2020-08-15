import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'dart:io';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  }
}


class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}



class SettingsScreenState extends State<SettingsScreen> {

  TextEditingController userNameTextEditingController;
  TextEditingController aboutMeTextEditingController;
  File imageFileAvatar;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataFromLocal();
  }

  readDataFromLocal() async{
    userNameTextEditingController = TextEditingController(
      text: Constants.preferences.getString(Constants.USERNAME));
    aboutMeTextEditingController = TextEditingController(
      text: Constants.preferences.getString(Constants.ABOUTME));

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image - Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: [
                      (imageFileAvatar == null)
                          ? (Constants.preferences.getString(Constants.PHOTOURL) != "")
                          ? Material(
                            //display already exiting - old image file
                            child: CachedNetworkImage(
                              placeholder: (context, url)=>Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation(Colors.lightBlueAccent),
                                ),
                              )
                            ),
                          )
                          : Icon(Icons.account_circle, size: 90.0, color: Colors.grey,)
                          : Material(
                            //display the new updated iamge here
                          ),
                      IconButton(

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}