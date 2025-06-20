import 'package:client_user/screens/login/components/login_footer_widget.dart';
import 'package:client_user/screens/login/components/login_form_widget.dart';
import 'package:client_user/screens/login/components/login_header_widget.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1
                LoginHeaderWidget(size: size),

                // Section 2
                const LoginForm(),

                // Section 3
                const LoginFooterWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
