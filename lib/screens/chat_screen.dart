import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/widgets/progress.dart';


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
  bool isdDisplaySticker;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    isdDisplaySticker = false;
    isLoading = false;
  }

  onFocusChange(){
    if(focusNode.hasFocus){
      // hide sticker whenever keypad  appears
      setState(() {
        isdDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: [
          Column(
            children: [
              //TODO crate List of Messages
              createListMessages(),

              //show Stickers
              (isdDisplaySticker ? createStickers() : Container()),

              //TODO input controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading(){
    return Positioned(
      child: isLoading ? circularProgress() : Container(),
    );
  }

  Future<bool> onBackPress(){
    if(isdDisplaySticker){
      setState(() {
        isdDisplaySticker = false;
      });
    }else{
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  createStickers(){
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              FlatButton(
                //onPressed: onSendMessage("mimi1", 2),
                child: Image.asset(
                  "assets/images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi2", 2),
                child: Image.asset(
                  "assets/images/mimi2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi3", 2),
                child: Image.asset(
                  "assets/images/mimi3.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: [
              FlatButton(
                //onPressed: onSendMessage("mimi4", 2),
                child: Image.asset(
                  "assets/images/mimi4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi5", 2),
                child: Image.asset(
                  "assets/images/mimi5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi6", 2),
                child: Image.asset(
                  "assets/images/mimi6.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: [
              FlatButton(
                //onPressed: onSendMessage("mimi7", 2),
                child: Image.asset(
                  "assets/images/mimi7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi8", 2),
                child: Image.asset(
                  "assets/images/mimi8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                //onPressed: onSendMessage("mimi9", 2),
                child: Image.asset(
                  "assets/images/mimi9.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color: Colors.white,
      ),
      padding: EdgeInsets.all((5.0)),
      height: 180.0,
    );
  }

  getSticker(){
    focusNode.unfocus();
    setState(() {
      isdDisplaySticker = !isdDisplaySticker;
    });
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
                onPressed: getSticker,
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
