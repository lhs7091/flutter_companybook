import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/model/models.dart';
import 'package:flutter_companybook/screens/account_setting_screen.dart';
import 'package:flutter_companybook/widgets/progress.dart';
import 'package:intl/intl.dart';
import 'package:flutter_companybook/screens/screens.dart';

class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  final String currentUserId = Constants.preferences.getString(Constants.USERID);

  searchHeader(){
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            icon: Icon(Icons.settings, size: 30.0, color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
            }
        )
      ],
      backgroundColor: Colors.lightBlue,
      title: Container(
        margin: new EdgeInsets.only(bottom: 4.0),
        child: TextFormField(
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
          controller: searchTextEditingController,
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)
            ),
            filled: true,
            prefixIcon: Icon(Icons.person_pin, color:Colors.white, size: 30.0,),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white,),
              onPressed: emptyTextFormField,
            ),
          ),
          onFieldSubmitted: controlSearching,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchHeader(),
      body: futureSearchResults == null
          ? displayNoSearchResultScreen()
          : displayUserFoundScreen(),
    );

  }

  displayNoSearchResultScreen(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(
              Icons.group,
              color: Colors.lightBlueAccent,
              size: 200.0,
            ),
            Text(
              "Search Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 50.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen(){
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        List<UserResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((documnet){
          User eachUser = User.fromDocument(documnet);
          UserResult userResult = UserResult(eachUser);
          if(currentUserId != documnet[Constants.USERID]){
            searchUserResult.add(userResult);
          }
        });
        return ListView(children: searchUserResult,);
      },
    );
  }

  controlSearching(String username){
    Future<QuerySnapshot> allFoundUsers = Firestore.instance.collection("users")
        .where("userName", isGreaterThanOrEqualTo: username).getDocuments();
    setState(() {
      futureSearchResults = allFoundUsers;
    });
  }


  emptyTextFormField(){
    searchTextEditingController.clear();
  }
}


class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: ()=>sendUserToChatPage(context),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.photoUrl),
                ),
                title: Text(
                  eachUser.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Joined : '+ DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(eachUser.created))),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendUserToChatPage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context)=>Chat(
            receiverId: eachUser.userId,
            receiverAvatar: eachUser.photoUrl,
            receiverName: eachUser.username,
        ))
    );
  }

}
