import 'package:client_user/constants/string_button.dart';
import 'package:client_user/constants/string_context.dart';
import 'package:client_user/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:client_user/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';
import 'package:client_user/screens/forget_password/forget_password_phone/forget_password_phone.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) => Container(
              height: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tForgetPasswordTitle,
                    style: textBigKanit,
                  ),
                  Text(
                    tForgetPasswordSubTitle,
                    style: textNormalQuicksan,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ForgetPasswordBtnWidget(
                    btnIcon: Icons.mail_outline_rounded,
                    title: tEmail,
                    subTitle: tResetViaEmail,
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const ForgetPasswordMailScreen());
                    },
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // ForgetPasswordBtnWidget(
                  //   btnIcon: Icons.mobile_friendly_rounded,
                  //   title: tInputPhone,
                  //   subTitle: tResetViaPhone,
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => const ForgetPasswordPhoneScreen());
                  //   },
                  // ),
                ],
              ),
            ));
  }
}
