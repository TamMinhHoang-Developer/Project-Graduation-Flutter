class ProductImage {
  late String image;
  late DateTime uploadAt;

  ProductImage({required this.image, required this.uploadAt});

  // hàm tạo từ Json object
  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      image: json['image'],
      uploadAt: DateTime.parse(json['uploadAt']),
    );
  }

  // chuyển đổi thành Json object
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'uploadAt': uploadAt.toIso8601String(),
    };
  }
}
