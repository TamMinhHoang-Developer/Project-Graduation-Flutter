// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class News {
  bool? isRead;
  int? CreateAt;
  String? UserCreate, IdUserCreate, Title, Message, Id;

  News(
      {this.Id,
      this.isRead,
      this.CreateAt,
      this.UserCreate,
      this.IdUserCreate,
      this.Message,
      this.Title});

  // hàm tạo từ Json object
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        Id: json['Id'],
        isRead: json['isRead'],
        CreateAt: json['CreateAt'],
        UserCreate: json['UserCreate'],
        IdUserCreate: json['IdUserCreate'],
        Title: json['Title'],
        Message: json['Message']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'isRead': isRead,
      'CreateAt': CreateAt,
      'UserCreate': UserCreate,
      'IdUserCreate': IdUserCreate,
      'Title': Title,
      'Message': Message
    };
  }

  String get formattedDate {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(CreateAt ?? 0);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }
}

class NewsSnapshot {
  News? orderDetail;
  DocumentReference? documentReference;

  NewsSnapshot({
    required this.orderDetail,
    required this.documentReference,
  });

  factory NewsSnapshot.fromSnapshot(DocumentSnapshot docSnapUser) {
    return NewsSnapshot(
        orderDetail: News.fromJson(docSnapUser.data() as Map<String, dynamic>),
        documentReference: docSnapUser.reference);
  }

  static Future<void> themMoiAutoId(News news, userId) async {
    CollectionReference usersRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection("News");
    DocumentReference newDocRef = usersRef.doc();
    news.Id = newDocRef.id;
    await newDocRef.set(news.toJson());
  }

  static Stream<List<NewsSnapshot>> getListNewsByAdmin() {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Admin")
        .doc("admin")
        .collection("News")
        .orderBy("isRead")
        .snapshots();
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) => listDocSnap
        .map((docSnap) => NewsSnapshot.fromSnapshot(docSnap))
        .toList());
  }

  static Future<void> updateNewsIsRead(
      String userId, String newsId, bool isRead) async {
    CollectionReference newsRef = FirebaseFirestore.instance
        .collection('Admin')
        .doc("admin")
        .collection('News');
    DocumentReference newsDocRef = newsRef.doc(newsId);

    await newsDocRef.update({'isRead': isRead});
  }

  static Stream<List<List<NewsSnapshot>>> getListNewsByUserGroupByDate(
      String idUser) {
    Stream<QuerySnapshot> qs = FirebaseFirestore.instance
        .collection("Admin")
        .doc("admin")
        .collection("News")
        .orderBy("isRead")
        .snapshots();
    if (qs == null) return const Stream.empty();
    Stream<List<DocumentSnapshot>> listDocSnap =
        qs.map((querySn) => querySn.docs);
    return listDocSnap.map((listDocSnap) {
      final groupedNews = <String, List<NewsSnapshot>>{};
      for (var docSnap in listDocSnap) {
        final newsSnapshot = NewsSnapshot.fromSnapshot(docSnap);
        final newsDate = formatDate(newsSnapshot.orderDetail!.CreateAt!);
        if (groupedNews.containsKey(newsDate)) {
          groupedNews[newsDate]!.add(newsSnapshot);
        } else {
          groupedNews[newsDate] = [newsSnapshot];
        }
      }
      return groupedNews.values.toList();
    });
  }

  static String formatDate(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static Future<void> markAllNewsAsRead(String idUser) async {
    CollectionReference newsRef = FirebaseFirestore.instance
        .collection('Admin')
        .doc("admin")
        .collection('News');

    QuerySnapshot querySnapshot = await newsRef.get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    for (QueryDocumentSnapshot document in documents) {
      await document.reference.update({'isRead': true});
    }
  }
}
