import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  ButtonWidget(
      {super.key,
      required this.text,
      this.radius,
      this.style,
      this.height,
      this.click});
  late String text;
  Function? click;
  double? height;
  TextStyle? style;
  double? radius;

  @override
  Widget build(BuildContext context) {
    Size screenWidth = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: () {},
      // ignore: sort_child_properties_last
      child: Text(
        text,
        style: style,
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          screenWidth.width - 80,
          height ?? 65,
        ),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ??
              20.0), // Tùy chỉnh giá trị này để thay đổi độ cong của đường viền
        ),
      ),
    );
  }
}
