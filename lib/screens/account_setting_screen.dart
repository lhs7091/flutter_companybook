import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/widgets/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../main.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Account Settings",
          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
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
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode aboutMeFocusNode = FocusNode();

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
  
  Future getImage() async{
    File newImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(newImageFile != null){
      setState(() {
        this.imageFileAvatar = newImageFile;
        isLoading = true;
      });
    }
    
    uploadImageToFirestoreAndStorage();
  }

  Future uploadImageToFirestoreAndStorage() async{
    String mFileName = Constants.preferences.getString(Constants.USERID);
    StorageReference storageReference = FirebaseStorage.instance.ref().child(mFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(imageFileAvatar);
    StorageTaskSnapshot storageTaskSnapshot;
    storageUploadTask.onComplete.then((value){
      if(value.error == null){
        storageTaskSnapshot = value;

        storageTaskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl){
          // update photourl of current user object
          Constants.preferences.setString(Constants.PHOTOURL, newImageDownloadUrl);

          // DB update
          Firestore.instance.collection("users")
            .document(Constants.preferences.getString(Constants.USERID))
            .updateData({
            Constants.PHOTOURL: newImageDownloadUrl,
            Constants.UPDATED : DateTime.now().millisecondsSinceEpoch.toString(),
          }).then((data)async{ // DB update success
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Updated Successfully.");
          });
        }, onError: (errorMsg){
          setState(() {
            isLoading = false;
          });
           Fluttertoast.showToast(msg: "Error occured in getting Download Url");
        });

      }
    }, onError: (errorMsg){ // fail to upload
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: errorMsg.toString());
    });
  }

  updateData(){
    userNameFocusNode.unfocus();
    aboutMeFocusNode.unfocus();
    setState(() {
      isLoading = false;
    });
    Firestore.instance.collection("users")
        .document(Constants.preferences.getString(Constants.USERID))
        .updateData({
      Constants.USERNAME: Constants.preferences.getString(Constants.USERNAME),
      Constants.ABOUTME: Constants.preferences.getString(Constants.ABOUTME),
      Constants.UPDATED : DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((data)async { // DB update success
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Updated Successfully.");
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
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(20.0)
                              ),
                              imageUrl: Constants.preferences.getString(Constants.PHOTOURL),
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(125.0)),
                            clipBehavior: Clip.hardEdge,
                          )
                          : Icon(Icons.account_circle, size: 90.0, color: Colors.grey,)
                          : Material(
                            //display the new updated iamge here
                            child: Image.file(
                              imageFileAvatar,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(125.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                      IconButton(
                        icon: Icon(Icons.camera_alt, size: 100.0, color: Colors.white54.withOpacity(0.3),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(0.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.grey,
                        iconSize: 200.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),
              // Input Field
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: isLoading ? circularProgress() : Container(),
                  ),
                  SizedBox(height: 20.0,),
                  // UserName
                  Container(
                    child: Text(
                      "Profile Name",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: Constants.preferences.getString(Constants.USERNAME),
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: userNameTextEditingController,
                        onChanged: (value){
                          Constants.preferences.setString(Constants.USERNAME, value);
                        },
                        focusNode: userNameFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                  SizedBox(height: 20.0,),
                  //aboutMe
                  Container(
                    child: Text(
                      "About Me",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor: Colors.lightBlueAccent),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: Constants.preferences.getString(Constants.ABOUTME),
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: aboutMeTextEditingController,
                        onChanged: (value){
                          Constants.preferences.setString(Constants.ABOUTME, value);
                        },
                        focusNode: aboutMeFocusNode,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              //Buttons
              Container(
                child: FlatButton(
                  onPressed: updateData,
                  color: Colors.blue,
                  highlightColor: Colors.grey,
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),

                margin: EdgeInsets.only(top: 30.0, bottom: 1.0),
              ),

              // Logout Button
              Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: logoutUser,
                  child: Text(
                    "LogOut",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),
      ],
    );
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Future<Null> logoutUser() async{
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    Constants.preferences = null;

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyApp()), (Route<dynamic> route) => false);

  }
}