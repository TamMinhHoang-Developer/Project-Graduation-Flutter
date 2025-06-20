import 'package:client_user/constants/string_img.dart';

class Category {
  const Category(this.icon, this.title, this.id);

  final String icon;
  final String title;
  final String id;
}

final homeCategries = <Category>[
  const Category(iSetup1, 'Sofa', 'sofa'),
  const Category(iSetup2, 'Chair', 'sofa'),
  const Category(iSetup3, 'Table', 'sofa'),
];
