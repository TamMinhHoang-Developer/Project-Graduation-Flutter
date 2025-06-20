import 'package:client_user/modal/product_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  // ignore: non_constant_identifier_names
  String? Description, Name, Type, Unit;
  // ignore: non_constant_identifier_names
  int? CreateAt, Price, Price_Sale;
  // ignore: non_constant_identifier_names
  String? Id;
  // ignore: non_constant_identifier_names
  bool? Sale;
  // ignore: non_constant_identifier_names
  late List<ProductImage>? Images;

  Products(
      {
      // ignore: non_constant_identifier_names
      this.Id,
      // ignore: non_constant_identifier_names
      this.Name,
      // ignore: non_constant_identifier_names
      this.Description,
      // ignore: non_constant_identifier_names
      this.Type,
      // ignore: non_constant_identifier_names
      this.CreateAt,
      // ignore: non_constant_identifier_names
      this.Price,
      // ignore: non_constant_identifier_names
      this.Price_Sale,
      // ignore: non_constant_identifier_names
      this.Sale,
      // ignore: non_constant_identifier_names
      this.Unit,
      // ignore: non_constant_identifier_names
      required this.Images});

  factory Products.fromJson(Map<String, dynamic> map) {
    var imagesJson = map['Images'] as List<dynamic>;
    List<ProductImage> images = imagesJson
        .map((imageJson) => ProductImage.fromJson(imageJson))
        .toList();

    return Products(
      Id: map['Id'],
      Name: map['Name'],
      Description: map['Description'],
      Type: map['Type'],
      CreateAt: map['CreateAt'],
      Price: map['Price'],
      Price_Sale: map['Price_Sale'],
      Sale: map['Sale'],
      Unit: map['Unit'],
      Images: images,
    );
  }

  Map<String, dynamic> toJson() {
    var imagesJson = Images!.map((image) => image.toJson()).toList();
    return {
      'Id': Id,
      'Name': Name,
      'Description': Description,
      'Type': Type,
      'CreateAt': CreateAt,
      'Price': Price,
      'Price_Sale': Price_Sale,
      'Sale': Sale,
      'Unit': Unit,
      'Images': imagesJson,
    };
  }
}

class ProductsSnapshot {
  Products? products;
  DocumentReference? documentReference;

  ProductsSnapshot({
    required this.products,
    required this.documentReference,
  });

  factory ProductsSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return ProductsSnapshot(
        products: Products.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }

  Future<void> capNhat(Products products) async {
    return documentReference!.update(products.toJson());
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<DocumentReference> themMoi(
      Products products, String idUser) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Products")
        .add(products.toJson());
  }

  static Future<void> themMoiAutoId(Products products, String idUser) async {
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(idUser)
        .collection("Products");
    DocumentReference newDocRef = usersRef.doc();
    products.Id = newDocRef.id;
    await newDocRef.set(products.toJson());
  }

  static Stream<List<ProductsSnapshot>> dsUserTuFirebase(String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Products")
        .orderBy("Sale")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => ProductsSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<List<ProductsSnapshot>> dsUserTuFirebaseOneTime(
      String idUser) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Products")
        .get();
    return qs.docs
        .map((docSnap) => ProductsSnapshot.fromSnapshot(docSnap))
        .toList();
  }
}
