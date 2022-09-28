// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DeleteNoteView extends StatelessWidget {
  const DeleteNoteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Waring!'),
      content: Text('Are you sure you want to delete this note?'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          icon: Icon(
            Icons.cancel,
            color: Colors.green,
            size: 30,
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: Icon(
              Icons.check,
              color: Colors.red,
              size: 30,
            )),
      ],
    );
  }
}
