// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    int pk;
    String user;
    int parentForum;
    String description;
    DateTime date;

    Comment({
        required this.pk,
        required this.user,
        required this.parentForum,
        required this.description,
        required this.date,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        pk: json["pk"],
        user: json["user"],
        parentForum: json["parentForum"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "user": user,
        "parentForum": parentForum,
        "description": description,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}
