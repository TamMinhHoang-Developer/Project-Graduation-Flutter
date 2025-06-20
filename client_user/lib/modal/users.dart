// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Users {
  String? Address, Avatar, Name, Email, PackageType, Password, Phone, Token;
  bool? Status, isAdmin;
  int? ActiveAt, CreatedAt;
  String? Id;
  Users(
      {this.Address,
      this.Avatar,
      this.Name,
      this.Email,
      this.PackageType,
      this.Phone,
      this.Password,
      this.Status,
      this.ActiveAt,
      this.Id,
      this.CreatedAt,
      this.isAdmin,
      this.Token});

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Address': Address,
      'Avatar': Avatar,
      'Name': Name,
      'Email': Email,
      'PackageType': PackageType,
      'Phone': Phone,
      'Password': Password,
      'Status': Status,
      'ActiveAt': ActiveAt,
      'CreatedAt': CreatedAt,
      'isAdmin': isAdmin,
      'Token': Token
    };
  }

  factory Users.fromJson(Map<String, dynamic> map) {
    return Users(
        Id: map['Id'],
        Address: map['Address'],
        Avatar: map['Avatar'],
        Name: map['Name'],
        Email: map['Email'],
        PackageType: map['PackageType'],
        Phone: map['Phone'],
        Password: map['Password'],
        Status: map['Status'],
        ActiveAt: map['ActiveAt'],
        CreatedAt: map['CreatedAt'],
        isAdmin: map['isAdmin'],
        Token: map['Token']);
  }
}

class UserSnapshot {
  Users? user;
  DocumentReference? documentReference;

  UserSnapshot({
    required this.user,
    required this.documentReference,
  });

  factory UserSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return UserSnapshot(
        user: Users.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }
  Future<void> capNhat(Users user) async {
    return documentReference!.update(user.toJson());
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<DocumentReference> themMoi(Users sv) async {
    return FirebaseFirestore.instance.collection("Users").add(sv.toJson());
  }

  static Future<void> themMoiAutoId(Users sv) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    DocumentReference newDocRef = usersRef.doc();
    sv.Id = newDocRef.id;
    sv.Token = await FirebaseMessaging.instance.getToken();
    await newDocRef.set(sv.toJson());
  }

  static Stream<List<UserSnapshot>> dsUserTuFirebase() {
    Stream<QuerySnapshot> qs =
        FirebaseFirestore.instance.collection("Users").snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => UserSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  // Check đc xem là đã được chuyển qua User hay chưa hay vẫn ở Wailting
  Future<Users> getUserData(String email) async {
    Users? user;
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var documentSnapshot = querySnapshot.docs.first;
      user = Users.fromJson(documentSnapshot.data());
      user.Token = await FirebaseMessaging.instance.getToken();
    }
    return user!;
  }

  static Stream<UserSnapshot> getUserAdminStream() {
    return FirebaseFirestore.instance
        .collection("Users")
        .where("isAdmin", isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((QuerySnapshot querySnapshot) =>
            UserSnapshot.fromSnapshot(querySnapshot.docs.first));
  }

  static Future<List<UserSnapshot>> dsUserTuFirebaseOneTime() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Users").get();
    return qs.docs
        .map((docSnap) => UserSnapshot.fromSnapshot(docSnap))
        .toList();
  }

  static Stream<UserSnapshot> getUser(String idUser) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .snapshots()
        .map((docSnapshot) => UserSnapshot.fromSnapshot(docSnapshot));
  }
}
