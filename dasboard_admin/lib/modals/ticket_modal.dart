import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  // ignore: non_constant_identifier_names
  int? CreateAt, Value, DurationActive;
  // ignore: non_constant_identifier_names
  String? IdTicket, Name, Unit;
  Ticket(
      // ignore: non_constant_identifier_names
      {
      // ignore: non_constant_identifier_names
      this.CreateAt,
      // ignore: non_constant_identifier_names
      this.Value,
      // ignore: non_constant_identifier_names
      this.DurationActive,
      // ignore: non_constant_identifier_names
      this.IdTicket,
      // ignore: non_constant_identifier_names
      this.Name,

      // ignore: non_constant_identifier_names
      this.Unit});

  Map<String, dynamic> toJson() {
    return {
      'CreateAt': CreateAt,
      'Value': Value,
      'DurationActive': DurationActive,
      'IdTicket': IdTicket,
      'Name': Name,
      'Unit': Unit
    };
  }

  factory Ticket.fromJson(Map<String, dynamic> map) {
    return Ticket(
        CreateAt: map['CreateAt'],
        Value: map['Value'],
        DurationActive: map['DurationActive'],
        IdTicket: map['IdTicket'],
        Name: map['Name'],
        Unit: map['Unit']);
  }
}

class TicketSnapshot {
  Ticket? ticket;
  DocumentReference? documentReference;

  TicketSnapshot({
    required this.ticket,
    required this.documentReference,
  });

  factory TicketSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return TicketSnapshot(
        ticket: Ticket.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }
  Future<void> capNhat(Ticket ticket) async {
    return documentReference!.update(ticket.toJson());
  }

  Future<void> xoa() async {
    return documentReference!.delete();
  }

  static Future<DocumentReference> themMoi(Ticket ticket) async {
    return FirebaseFirestore.instance.collection("Ticket").add(ticket.toJson());
  }

  static Future<void> themMoiAutoId(Ticket sv) async {
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Ticket');
    DocumentReference newDocRef = usersRef.doc();
    sv.IdTicket = newDocRef.id;
    await newDocRef.set(sv.toJson());
  }

  static Stream<List<TicketSnapshot>> getAllTicketFormFirebase() {
    Stream<QuerySnapshot> qs =
        FirebaseFirestore.instance.collection("Ticket").snapshots();
    // ignore: unnecessary_null_comparison
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => TicketSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<List<TicketSnapshot>> getAllTicketFormFirebaseOneTime() async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection("Ticket").get();
    return qs.docs
        .map((docSnap) => TicketSnapshot.fromSnapshot(docSnap))
        .toList();
  }
}
