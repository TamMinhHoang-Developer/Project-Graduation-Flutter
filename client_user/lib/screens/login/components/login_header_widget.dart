import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          iLogin4,
          height: size.height * 0.2,
        ),
        Text(
          tTitleLogin,
          style: textBigKanit,
        ),
        Text(tDesLogin, style: textNormalQuicksan),
      ],
    );
  }
}
