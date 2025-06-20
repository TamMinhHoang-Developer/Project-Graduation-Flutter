// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  String? Address, Avatar, Email, Id, Name, Phone, Salary, Sex;
  int? Age, Birthday;

  Seller(
      {this.Id,
      this.Name,
      this.Address,
      this.Avatar,
      this.Age,
      this.Sex,
      this.Phone,
      this.Email,
      this.Salary,
      this.Birthday});

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Address': Address,
      'Avatar': Avatar,
      'Name': Name,
      'Email': Email,
      'Age': Age,
      'Phone': Phone,
      'Sex': Sex,
      'Salary': Salary,
      'Birthday': Birthday
    };
  }

  factory Seller.fromJson(Map<String, dynamic> map) {
    return Seller(
        Id: map['Id'],
        Address: map['Address'],
        Avatar: map['Avatar'],
        Name: map['Name'],
        Email: map['Email'],
        Age: map['Age'],
        Phone: map['Phone'],
        Sex: map['Sex'],
        Salary: map['Salary'],
        Birthday: map['Birthday']);
  }
}

class SellerSnapshot {
  Seller? seller;
  DocumentReference? documentReference;

  SellerSnapshot({
    required this.seller,
    required this.documentReference,
  });

  factory SellerSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return SellerSnapshot(
        seller: Seller.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }
  Future<void> capNhat(Seller seller) async {
    return documentReference!.update(seller.toJson());
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<DocumentReference> themMoi(Seller seller, String idUser) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Sellers")
        .add(seller.toJson());
  }

  static Future<void> themMoiAutoId(Seller sv, String idUser) async {
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Sellers");
    DocumentReference newDocRef = usersRef.doc();
    sv.Id = newDocRef.id;
    await newDocRef.set(sv.toJson());
  }

  static Stream<List<SellerSnapshot>> dsSellerTuFirebase(String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Sellers")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => SellerSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<List<SellerSnapshot>> dsTableTuFirebaseOneTime(
      String idUser) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Sellers")
        .get();
    return qs.docs
        .map((docSnap) => SellerSnapshot.fromSnapshot(docSnap))
        .toList();
  }
}
