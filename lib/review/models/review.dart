import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String book;
    int user;
    String content;
    int rating;
    DateTime reviewDate;

    Fields({
        required this.book,
        required this.user,
        required this.content,
        required this.rating,
        required this.reviewDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        user: json["user"],
        content: json["content"],
        rating: json["rating"],
        reviewDate: DateTime.parse(json["review_date"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "user": user,
        "content": content,
        "rating": rating,
        "review_date": reviewDate.toIso8601String(),
    };
}
