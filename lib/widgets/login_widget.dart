import 'package:flutter/material.dart';

InputDecoration textFieldInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
  );
}

TextStyle simpleTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 20.0
  );
}

TextStyle mediumTextFieldStyle(){
  return TextStyle(
      color: Colors.white,
      fontSize: 17.0
  );
}