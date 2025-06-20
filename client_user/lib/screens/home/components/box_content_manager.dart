import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class BoxContentManager extends StatelessWidget {
  const BoxContentManager({
    super.key,
    required this.nameManager,
    required this.subnameManager,
    required this.total,
    this.onPressed,
  });

  final String nameManager;
  final String subnameManager;
  final int total;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 170,
        height: 50,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: bgBlack),
              child: Center(
                child: Text(
                  nameManager,
                  style: textSmallQuicksanWhite,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subnameManager,
                    style: textNormalQuicksanBold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$total $subnameManager",
                    style: textNormalQuicksan,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
