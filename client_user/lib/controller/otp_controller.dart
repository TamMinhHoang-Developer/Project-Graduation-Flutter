import 'package:client_user/repository/auth_repository/auth_repository.dart';
import 'package:client_user/screens/home/screen_home.dart';
import 'package:get/get.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifiOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(const ScreenHome()) : Get.back();
  }
}
