import 'package:client_user/modal/users.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatelessWidget {
  const MyHeaderDrawer({super.key, this.user});

  final Users? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: padua,
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: NetworkImage(user!.Avatar!))),
          ),
          Text(
            user!.Email!,
            style: textAppKanit,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            user!.Name!,
            style: textXLQuicksan,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
