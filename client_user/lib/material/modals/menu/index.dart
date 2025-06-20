import 'package:client_user/material/bilions_ui.dart';
import 'package:client_user/material/color/app_colors.dart';
import 'package:flutter/material.dart';

menu(BuildContext context, Widget widget,
    {Color? backgroundColor, double? radius, Color? barColor}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: backgroundColor ?? BilionsColors.modalBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius ?? 20),
        topRight: Radius.circular(radius ?? 20),
      ),
    ),
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mb(0.5),
        Container(
          height: 4,
          width: 50,
          decoration: BoxDecoration(
            color: barColor ?? BilionsColors.primary,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          child: widget,
        ),
      ],
    ),
  );
}
