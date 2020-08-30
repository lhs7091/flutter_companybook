import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/screens/screens.dart';

class CreatePostContainer extends StatelessWidget {
  final User currentUser = Constants.firebaseUser;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 0.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettings()));
                },
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: CachedNetworkImageProvider(Constants.preferences.getString(Constants.PHOTOURL)),
                  //backgroundImage: CachedNetworkImageProvider("https://firebasestorage.googleapis.com/v0/b/companybooktutorial.appspot.com/o/default.png?alt=media&token=9c189e0c-4be1-4b6b-aa13-b91834f430fc"),
                ),
              ),
              const SizedBox(width: 8.0,),
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87,),
                  decoration: InputDecoration.collapsed(
                    hintText: Constants.preferences.getString("aboutMe"),
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            height: 10.0,
            thickness: 0.5,
          ),
          Container(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton.icon(
                    onPressed: ()=>print("Chat Room"),
                    icon: const Icon(Icons.chat, color: Colors.red),
                    label: Text('ChatRoom')
                ),
                const VerticalDivider(width: 4.0,),
                FlatButton.icon(
                    onPressed: ()=>print("Video Call"),
                    icon: const Icon(Icons.video_call, color: Colors.green),
                    label: Text('VideoCall'),
                ),
                const VerticalDivider(width: 4.0,),
                FlatButton.icon(
                    onPressed: ()=>print("Photo"),
                    icon: const Icon(Icons.photo, color: Colors.purple),
                    label: Text('Photo')
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
