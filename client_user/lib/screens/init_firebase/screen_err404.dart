import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/shared/button/button_widget.dart';
import 'package:client_user/uilt/style/button_style/button_style.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class ScreenErr404 extends StatefulWidget {
  const ScreenErr404({super.key});

  @override
  State<ScreenErr404> createState() => _ScreenErr404State();
}

class _ScreenErr404State extends State<ScreenErr404> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                i404v1,
                width: 250,
                cacheWidth: 250,
              ),
              Text(
                tTitle404,
                style: textHeader,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                tDes404,
                style: textTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              ButtonWidget(
                text: tButton404,
                style: normalButton,
                radius: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
