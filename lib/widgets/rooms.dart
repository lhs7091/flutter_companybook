import 'package:flutter/material.dart';
import 'package:flutter_companybook/model/online_users.dart';

class Rooms extends StatefulWidget {

  List<OnlineUser> onlineUsers;

  Rooms(this.onlineUsers);

  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {

  @override
  Widget build(BuildContext context) {
    widget.onlineUsers.toString();
    return Container(
      height: 60.0,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 4.0,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 1+5,//widget.onlineUsers.length,
        itemBuilder: (context, index){
          if(index ==0){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _CreateRoomButton(),
            );
          }
          return Container(
            margin: const EdgeInsets.all(2.0),
            height: 20.0,
            width: 20.0,
            color: Colors.red,
          );
        },
      ),
    );
  }
}

class _CreateRoomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
