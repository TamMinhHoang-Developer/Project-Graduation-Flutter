// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Tables {
  String? Id, Name;
  String? Status;
  int? Slot;

  Tables({this.Id, this.Name, this.Slot, this.Status});

  Map<String, dynamic> toJson() {
    return {'Id': Id, 'Name': Name, 'Status': Status, 'Slot': Slot};
  }

  factory Tables.fromJson(Map<String, dynamic> map) {
    return Tables(
        Id: map['Id'],
        Name: map['Name'],
        Status: map['Status'],
        Slot: map['Slot']);
  }
}

class TableSnapshot {
  Tables? table;
  DocumentReference? documentReference;

  TableSnapshot({
    required this.table,
    required this.documentReference,
  });

  factory TableSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return TableSnapshot(
        table: Tables.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }
  Future<void> capNhat(Tables tables) async {
    return documentReference!.update(tables.toJson());
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<DocumentReference> themMoi(Tables table, String idUser) async {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Tables")
        .add(table.toJson());
  }

  static Future<void> themMoiAutoId(Tables sv, String idUser) async {
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Tables");
    DocumentReference newDocRef = usersRef.doc();
    sv.Id = newDocRef.id;
    await newDocRef.set(sv.toJson());
  }

  static Stream<List<TableSnapshot>> dsUserTuFirebase(String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Tables")
        .orderBy("Status")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => TableSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<List<TableSnapshot>> dsTableTuFirebaseOneTime(
      String idUser) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Tables")
        .get();
    return qs.docs
        .map((docSnap) => TableSnapshot.fromSnapshot(docSnap))
        .toList();
  }

  static Stream<List<TableSnapshot>> dsUserTuFirebaseFilter(
      String idUser, String statusFilter) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Users")
        .doc(idUser)
        .collection("Tables")
        .orderBy("Status")
        .snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);

    return listDocSnap.map((listDocSnap) {
      List<TableSnapshot> tableList = listDocSnap
          .map((docSnap) => TableSnapshot.fromSnapshot(docSnap))
          .toList();

      if (statusFilter != null) {
        tableList = tableList
            .where((table) => table.table!.Status == statusFilter.toString())
            .toList();
      }

      return tableList;
    });
  }
}
