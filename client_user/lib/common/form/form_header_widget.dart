import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.subTitle,
      this.imageColor,
      this.imageHeight = 0.2,
      this.heightBetween,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.textAlign});

  final String image, title, subTitle;
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image.asset(
          image,
          color: imageColor,
          height: size.height * imageHeight,
        ),
        SizedBox(
          height: heightBetween,
        ),
        Text(
          title,
          style: textBigKanit,
        ),
        Text(
          subTitle,
          style: textNormalQuicksan,
          textAlign: textAlign,
        ),
      ],
    );
  }
}
