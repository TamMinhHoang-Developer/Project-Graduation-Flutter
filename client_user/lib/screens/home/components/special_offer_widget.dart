import 'package:client_user/constants/const_spacer.dart';
import 'package:client_user/modal/custom_modal/home_category.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecialOfferWidget extends StatelessWidget {
  const SpecialOfferWidget(
    this.context, {
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final SpecialOffer data;
  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.discount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 40),
                ),
                const SizedBox(height: 7),
                Text(
                  data.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        Image.asset(
          data.icon,
          width: 150,
          height: 150,
        ),
      ],
    );
  }
}
