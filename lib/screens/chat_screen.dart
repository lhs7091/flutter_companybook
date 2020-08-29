import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_companybook/config/constants.dart';
import 'package:flutter_companybook/widgets/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';



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
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isdDisplaySticker;
  bool isLoading;

  File imageFile;
  String imageUrl;

  String chatId;
  String id;
  var listmessage;


  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    isdDisplaySticker = false;
    isLoading = false;

    chatId="";
    readLocal();
  }

  readLocal() async{
    id = Constants.preferences.getString(Constants.USERID) ?? "";
    if(id.hashCode <= receiverId.hashCode){
      chatId = '$id-$receiverId';
    }else{
      chatId = '$receiverId-$id';
    }
    Firestore.instance.collection("users").document(id).updateData({'chattingWith':receiverId});
    setState(() {

    });
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
                onPressed: ()=>onSendMessage("mimi1", 2),
                child: Image.asset(
                  "assets/images/mimi1.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: ()=>onSendMessage("mimi2", 2),
                child: Image.asset(
                  "assets/images/mimi2.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: ()=>onSendMessage("mimi3", 2),
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
                onPressed:()=> onSendMessage("mimi4", 2),
                child: Image.asset(
                  "assets/images/mimi4.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: ()=>onSendMessage("mimi5", 2),
                child: Image.asset(
                  "assets/images/mimi5.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed:()=> onSendMessage("mimi6", 2),
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
                onPressed:()=> onSendMessage("mimi7", 2),
                child: Image.asset(
                  "assets/images/mimi7.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed:()=> onSendMessage("mimi8", 2),
                child: Image.asset(
                  "assets/images/mimi8.gif",
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed:()=> onSendMessage("mimi9", 2),
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
      child: chatId == ""
      ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
        ),
      )
      : StreamBuilder(
        stream: Firestore.instance.collection("messages").document(chatId).collection(chatId).orderBy("timestamp", descending: true).limit(20).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
              ),
            );
            }else{
              listmessage = snapshot.data.documents;
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index)=>createItem(index, snapshot.data.documents[index]),
                itemCount: snapshot.data.documents.length,
                reverse: true,
                controller: listScrollController,
              );
          }
        },
      ),
    );
  }
  bool isLastMsgLeft(int index){
    if((index>0 && listmessage !=null && listmessage[index-1]["idFrom"]==id) || index==0){
      return true;
    }
    return false;
  }

  bool isLastMsgRight(int index){
    if((index>0 && listmessage !=null && listmessage[index-1]["idFrom"]!=id) || index==0){
      return true;
    }
    return false;
  }

  Widget createItem(int index, DocumentSnapshot document){
    // My messages - Right Side
    if(document["idFrom"] == id){
      return Row(
        children: [
          document["type"] == 0
              //Text Msg
              ? Container(
                child: Text(
                  document["content"],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(color: Colors.lightBlueAccent, borderRadius: BorderRadius.circular(15.0)),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
              )
              //Image msg
              : document["type"] == 1
              ? Container(
                child: FlatButton(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url)=>Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                        ),
                      ),
                      errorWidget: (context, url, error)=>Material(
                        child: Image.asset("assets/images/img_not_available.jpeg", width: 200.0, height: 200.0, fit: BoxFit.cover,),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: document["content"],
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>FullPhoto(url: document["content"]),
                    ));
                  },
                ),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0:10.0, right: 10.0),
              )
              //emoji msg
              : Container(
                child: Image.asset(
                  "assets/images/${document['content']}.gif",
                  width: 100.0,
                  height: 100.0,
                  fit:BoxFit.cover,
                ),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0:10.0, right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );

    //Receiver Message - Left side
    }else{
      return Container(
        child: Column(
          children: [
            Row(
              children: [
                isLastMsgLeft(index)
                  ? Material(
                    //display receiver profile image
                    child: CachedNetworkImage(
                      placeholder: (context, url)=>Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                        ),
                        width: 35.0,
                        height: 35.0,
                        padding: EdgeInsets.all(10.0),
                      ),
                      imageUrl: receiverAvatar,
                      width: 35.0,
                      height: 35.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(18.0),),
                    clipBehavior: Clip.hardEdge,
                   )
                  : Container(
                    width: 35.0,
                    ),

                document["type"] == 0
                    ? Container(
                  child: Text(
                    document["content"],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                //Image msg
                    : document["type"] == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url)=>Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(8.0))
                          ),
                        ),
                        errorWidget: (context, url, error)=>Material(
                          child: Image.asset("assets/images/img_not_available.jpeg", width: 200.0, height: 200.0, fit: BoxFit.cover,),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>FullPhoto(url: document["content"]),
                      ));
                    },
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                //emoji msg
                    : Container(
                  child: Image.asset(
                    "assets/images/${document['content']}.gif",
                    width: 100.0,
                    height: 100.0,
                    fit:BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),

            //Msg time
            isLastMsgLeft(index)
                ? Container(
                    child: Text(
                      DateFormat("dd MMM, yyyy - hh:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(document["timestamp"]))),
                      style: TextStyle(color:Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
                  )
                : Container(),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }

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
                onPressed: getImage,
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
                onPressed: ()=>onSendMessage(textEditingController.text, 0),
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

  void onSendMessage(String contentMsg, int type){
    //type=0, text msg
    //type=1, imageFile
    //type=2, emoji
    if(contentMsg != ""){
      textEditingController.clear();

      var docRef = Firestore.instance.collection("messages")
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now()
          .millisecondsSinceEpoch
          .toString());

      Firestore.instance.runTransaction((transaction) async{
        await transaction.set(docRef, {
          "idFrom": id,
          "idTo": receiverId,
          "timestamp":DateTime.now().millisecondsSinceEpoch.toString(),
          "content":contentMsg,
          "type":type,
        },);
      });

      listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    }else{
      Fluttertoast.showToast(msg: "Empty Message. Can not be sent.");
    }

  }

  getImage() async{
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile != null){
      isLoading = true;
    }
    uploadImageFile();
  }

  Future uploadImageFile() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (error){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error:"+error);
    });
  }
}
