import 'package:dasboard_admin/ulti/styles/main_styles.dart';
import 'package:flutter/material.dart';

class ModalBottomAddUser extends StatefulWidget {
  const ModalBottomAddUser({super.key});

  @override
  State<ModalBottomAddUser> createState() => _ModalBottomAddUserState();
}

class _ModalBottomAddUserState extends State<ModalBottomAddUser> {
  late TextEditingController txtName;
  late TextEditingController txtAddress;
  late TextEditingController txtEmail;
  late TextEditingController txtPhone;
  late TextEditingController txtActiveDate;
  late TextEditingController txtCreateDate;

  @override
  void initState() {
    super.initState();
    txtName = TextEditingController();
    txtAddress = TextEditingController();
    txtEmail = TextEditingController();
    txtPhone = TextEditingController();
    txtActiveDate = TextEditingController();
    txtCreateDate = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ignore: avoid_unnecessary_containers
                Container(
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Text(
                            "Add",
                            style: textMonster,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.person,
                        size: 30,
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      weight: 900,
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
