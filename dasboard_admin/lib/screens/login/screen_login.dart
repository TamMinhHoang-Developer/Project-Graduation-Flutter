import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dasboard_admin/controllers/login_controller.dart';
import 'package:dasboard_admin/screens/dashboard/screen_dashboard.dart';
import 'package:dasboard_admin/screens/panigator/main_panigator_page.dart';
import 'package:dasboard_admin/ulti/theme/theme.dart';
import 'package:dasboard_admin/widgets/form_custom_widget/input_field.dart';
import 'package:dasboard_admin/widgets/form_custom_widget/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  bool passwordVisible = false;
  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void dispose() {
    txtName.dispose();
    txtPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cu = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Login to your\naccount ADMIN',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/accent.png',
                    width: 99,
                    height: 4,
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      hintText: 'Email',
                      suffixIcon: const SizedBox(),
                      prefexIcon: const Icon(Icons.alternate_email_sharp),
                      controller: txtName,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InputField(
                      hintText: 'Password',
                      controller: txtPass,
                      prefexIcon: const Icon(Icons.key),
                      obscureText: !passwordVisible,
                      suffixIcon: IconButton(
                        color: textGrey,
                        splashRadius: 1,
                        icon: Icon(passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: togglePassword,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const SizedBox(
                height: 32,
              ),
              CustomPrimaryButton(
                buttonColor: primaryBlue,
                textValue: 'Login',
                textColor: Colors.white,
                onPressed: () async {
                  cu.login(txtName.text, txtPass.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
