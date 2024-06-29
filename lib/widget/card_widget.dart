import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final Function() onpress;
  const CardWidget({super.key, required this.title, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: IconButton(
              onPressed: onpress,
              icon: const Icon(Icons.delete)),
        ),
      ),
    );
  }
}
