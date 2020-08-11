import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {

  final IconData icon;
  final double iconSize;
  final Function onPressed;


  const CircleButton({
    Key key,
    this.icon,
    this.iconSize,
    this.onPressed
  }):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: iconSize,
        color:Colors.black,
        onPressed: onPressed,
      ),
    );
  }
}
