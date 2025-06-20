import 'package:client_user/modal/screen_modal/screen_onboarding.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.modal,
  });

  final OnBoardingModel modal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: modal.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            modal.image,
            height: modal.height * 0.3,
          ),
          Column(
            children: [
              Text(
                modal.titlel,
                style: textBigKanit,
                textAlign: TextAlign.center,
              ),
              Text(
                modal.subtitle,
                style: textXLQuicksan,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            modal.couterText,
            style: textCouterKanit,
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
