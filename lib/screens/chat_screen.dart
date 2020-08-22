import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  Chat({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
  }):super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
           padding: EdgeInsets.all(0.0),
           child: CircleAvatar(
             backgroundColor: Colors.black,
             backgroundImage: CachedNetworkImageProvider(receiverAvatar),
           ),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          receiverName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(receiverId: receiverId, receiverAvatar: receiverAvatar),
    );
  }
}


class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;

  ChatScreen({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
  }):super(key:key);

  @override
  _ChatScreenState createState() => _ChatScreenState(receiverId: receiverId, receiverAvatar: receiverAvatar);
}

class _ChatScreenState extends State<ChatScreen> {
  final String receiverId;
  final String receiverAvatar;

  _ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
  });

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              //TODO crate List of Messages
              createListMessages(),
              //TODO input controllers
              createInput(),
            ],
          ),
        ],
      ),
    );
  }
  createListMessages(){
    return Flexible(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      ),
    );
  }

  createInput(){
    return Container(
      child: Row(
        children: [
          // pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.lightBlueAccent,
                onPressed: ()=>print("clicked"),
              ),
            ),
            color: Colors.white,
          ),
          // emoji icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                color: Colors.lightBlueAccent,
                onPressed: ()=>print("clicked"),
              ),
            ),
            color: Colors.white,
          ),
          //Text Field
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: "Write here...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),
          // send message Icon Button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.lightBlueAccent,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
    );
  }
}
