import 'package:flutter/material.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
          ),
          ListTile(
            title: Text('Copy'),
            leading: Icon(Icons.content_copy),
          ),
          ListTile(
            title: Text('Cut'),
            leading: Icon(Icons.content_cut),
          ),
          ListTile(
            title: Text('Move'),
            leading: Icon(Icons.folder_open),
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
          )
        ],
      ),
    ));
  }
}
