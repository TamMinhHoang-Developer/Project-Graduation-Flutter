import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:client_user/constants/string_context.dart';
import 'package:client_user/constants/string_img.dart';
import 'package:client_user/modal/screen_modal/screen_onboarding.dart';
import 'package:client_user/screens/onboarding/components/onboarding_page.dart';
import 'package:client_user/uilt/style/color/color_main.dart';
import 'package:client_user/uilt/style/text_style/text_style.dart';

// ignore: use_key_in_widget_constructors
class ScreenOnboarding extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ScreenOnboardingState createState() => _ScreenOnboardingState();
}

class _ScreenOnboardingState extends State<ScreenOnboarding> {
  late LiquidController controller;

  int currentPage = 0;

  @override
  void initState() {
    controller = LiquidController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final pages = [
      OnBoardingPage(
          modal: OnBoardingModel(
              image: iOnboarding,
              titlel: tOnboardingScreen1,
              subtitle: tOnboardingScreen1Des,
              couterText: tOnboardingCouter1,
              backgroundColor: cOnboardingPage1Color,
              height: size.height)),
      OnBoardingPage(
          modal: OnBoardingModel(
              image: iOnboarding1,
              titlel: tOnboardingScreen2,
              subtitle: tOnboardingScreen2Des,
              couterText: tOnboardingCouter2,
              backgroundColor: cOnboardingPage2Color,
              height: size.height)),
      OnBoardingPage(
          modal: OnBoardingModel(
              image: iOnboarding2,
              titlel: tOnboardingScreen3,
              subtitle: tOnboardingScreen3Des,
              couterText: tOnboardingCouter3,
              backgroundColor: cOnboardingPage3Color,
              height: size.height))
    ];

    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              liquidController: controller,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              enableSideReveal: true,
              onPageChangeCallback: onPageChangeCallback,
            ),
            Positioned(
                bottom: 60.0,
                child: OutlinedButton(
                  onPressed: () {
                    int nextPage = controller.currentPage + 1;
                    controller.animateToPage(page: nextPage);
                    if (nextPage == 3) {
                      // ignore: avoid_print
                      print("Login");
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: Container(
                    decoration:
                        BoxDecoration(color: bgBlack, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(20),
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      // ignore: deprecated_member_use
                      onPrimary: Colors.white),
                )),
            Positioned(
                top: 20,
                right: 20,
                child: TextButton(
                    child: Text(
                      "Skip".toUpperCase(),
                      style: textCouterKanit,
                    ),
                    onPressed: () => controller.jumpToPage(page: 2))),
            Positioned(
                bottom: 15,
                child: AnimatedSmoothIndicator(
                  activeIndex: controller.currentPage,
                  count: 3,
                  effect: const WormEffect(
                      activeDotColor: Color(0xff272727), dotHeight: 7.0),
                ))
          ],
        ),
      ),
    );
  }

  void onPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
