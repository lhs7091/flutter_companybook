import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoScreen extends StatefulWidget {
  final String url;

  FullPhotoScreen({
    Key key,
    this.url
  }):super(key:key);

  @override
  _FullPhotoScreenState createState() => _FullPhotoScreenState(url:url);
}

class _FullPhotoScreenState extends State<FullPhotoScreen> {

  final String url;
  _FullPhotoScreenState({Key key, this.url});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}
