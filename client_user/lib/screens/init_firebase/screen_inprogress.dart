import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class ScreenInprogress extends StatefulWidget {
  const ScreenInprogress({super.key});

  @override
  State<ScreenInprogress> createState() => _ScreenInprogressState();
}

class _ScreenInprogressState extends State<ScreenInprogress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                i404v1,
                width: 400,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                tTitleInprogress,
                style: textHeader,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                tDesInprogress,
                style: textTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
