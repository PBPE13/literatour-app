// To parse this JSON data, do
//
//     final diary = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String model;
  int pk;
  Fields fields;

  Product({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
  int user;
  String title;
  DateTime finishDate;
  String notes;

  Fields({
    required this.user,
    required this.title,
    required this.finishDate,
    required this.notes,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        finishDate: DateTime.parse(json["date"]),
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "finishDate":
            "${finishDate.year.toString().padLeft(4, '0')}-${finishDate.month.toString().padLeft(2, '0')}-${finishDate.day.toString().padLeft(2, '0')}",
        "notes": notes,
      };
}