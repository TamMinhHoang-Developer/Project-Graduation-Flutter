class MyNotificationMessage {
  String? title, body, from, time, image;

  MyNotificationMessage(
      {this.title, this.body, this.from, this.time, this.image});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'from': from,
      'time': time,
      'image': image,
    };
  }

  factory MyNotificationMessage.fromJson(Map<String, dynamic> map) {
    return MyNotificationMessage(
      title: map['title'] as String?,
      body: map['body'] as String?,
      from: map['from'] as String?,
      time: map['time'] as String?,
      image: map['image'] as String?,
    );
  }
}
