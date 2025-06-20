import 'package:client_user/constants/string_img.dart';

class SpecialOffer {
  final String discount;
  final String title;
  final String detail;
  final String icon;

  SpecialOffer({
    required this.discount,
    required this.title,
    required this.detail,
    required this.icon,
  });
}

final homeSpecialOffers = <SpecialOffer>[
  SpecialOffer(
    discount: 'Table',
    title: "Manager Table For Now!",
    detail: 'Create Table Now',
    icon: iSetup1,
  ),
  SpecialOffer(
    discount: 'Product',
    title: "Manager Product For Now!",
    detail: 'Create Product Now',
    icon: iSetup2,
  ),
  SpecialOffer(
    discount: 'Seller',
    title: "Manager Seller For Now!",
    detail: 'Create Seller Now',
    icon: iSetup3,
  ),
];
