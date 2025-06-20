import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyFirebaseConnect extends StatefulWidget {
  final Widget Function(BuildContext context)? builder;
  final Widget Function(BuildContext context)? builderError;
  final Widget Function(BuildContext context)? builderConnect;
  const MyFirebaseConnect(
      {Key? key,
      required this.builder,
      required this.builderError,
      required this.builderConnect})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyFirebaseConnectState createState() => _MyFirebaseConnectState();
}

class _MyFirebaseConnectState extends State<MyFirebaseConnect> {
  bool ketNoi = false;
  bool loi = false;
  @override
  Widget build(BuildContext context) {
    if (loi) {
      return widget.builderError!(context);
    } else if (!ketNoi) {
      return widget.builderConnect!(context);
    } else {
      return widget.builder!(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _khoiTaoFirebase();
  }

  _khoiTaoFirebase() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        ketNoi = true;
      });
    } catch (e) {
      setState(() {
        loi = true;
      });
    }
  }
}
