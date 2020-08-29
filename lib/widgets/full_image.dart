import 'package:flutter/material.dart';
import 'package:flutter_companybook/screens/screens.dart';

class FullPhoto extends StatelessWidget {
  final String url;

  FullPhoto({
    Key key,
    this.url
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          "Full Image",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}



