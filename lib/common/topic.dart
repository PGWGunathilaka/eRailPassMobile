import 'package:flutter/material.dart';

class Topic extends StatelessWidget {
  final double? fontSize;

  const Topic({super.key, this.fontSize = 40.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Digital train Ticketing System',
      style: TextStyle(
        fontFamily: 'Lobster',
        inherit: true,
        fontSize: fontSize,
        color: Colors.black,
        shadows: const [
          Shadow(
              // bottomLeft
              offset: Offset(-2.0, -2.0),
              color: Colors.white),
          Shadow(
              // bottomRight
              offset: Offset(2.0, 2.0),
              color: Colors.white),
          Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: Colors.white),
          Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: Colors.white),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
