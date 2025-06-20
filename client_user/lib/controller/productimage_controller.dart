// ignore_for_file: avoid_print

import 'package:client_user/modal/product_image.dart';
import 'package:get/get.dart';

class ProductImageController extends GetxController {
  static ProductImageController get instance => Get.find();
  RxList<ProductImage> product = RxList<ProductImage>();

  addListProductImage(List<ProductImage> list) {
    product(list);
    print(product.length);
  }

  clearListImage() {
    product.clear();
  }
}
