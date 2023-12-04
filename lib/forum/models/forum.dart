// To parse this JSON data, do
//
//     final forumPost = forumPostFromJson(jsonString);

import 'dart:convert';

List<ForumPost> forumPostFromJson(String str) => List<ForumPost>.from(json.decode(str).map((x) => ForumPost.fromJson(x)));

String forumPostToJson(List<ForumPost> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumPost {
    int pk;
    String user;
    String topic;
    String description;
    DateTime date;
    String title;

    ForumPost({
        required this.pk,
        required this.user,
        required this.topic,
        required this.description,
        required this.date,
        required this.title,
    });

    factory ForumPost.fromJson(Map<String, dynamic> json) => ForumPost(
        pk: json["pk"],
        user: json["user"],
        topic: json["topic"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "user": user,
        "topic": topic,
        "description": description,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "title": title,
    };
}
