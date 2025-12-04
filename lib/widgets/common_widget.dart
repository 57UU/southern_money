import 'package:flutter/material.dart';

Widget TitleText(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}

late BuildContext logicRootContext;

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/avatar.png');
  }
}
