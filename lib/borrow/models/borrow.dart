// To parse this JSON data, do
//
//     final borrow = borrowFromJson(jsonString);

import 'dart:convert';

List<Borrow> borrowFromJson(String str) => List<Borrow>.from(json.decode(str).map((x) => Borrow.fromJson(x)));

String borrowToJson(List<Borrow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Borrow {
    Model model;
    int pk;
    Fields fields;

    Borrow({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Borrow.fromJson(Map<String, dynamic> json) => Borrow(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int book;
    int borrower;
    DateTime borrowDate;
    DateTime returnDate;

    Fields({
        required this.book,
        required this.borrower,
        required this.borrowDate,
        required this.returnDate,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        book: json["book"],
        borrower: json["borrower"],
        borrowDate: DateTime.parse(json["borrow_date"]),
        returnDate: DateTime.parse(json["return_date"]),
    );

    Map<String, dynamic> toJson() => {
        "book": book,
        "borrower": borrower,
        "borrow_date": "${borrowDate.year.toString().padLeft(4, '0')}-${borrowDate.month.toString().padLeft(2, '0')}-${borrowDate.day.toString().padLeft(2, '0')}",
        "return_date": "${returnDate.year.toString().padLeft(4, '0')}-${returnDate.month.toString().padLeft(2, '0')}-${returnDate.day.toString().padLeft(2, '0')}",
    };
}

enum Model {
    BORROW_BOOK_BORROW
}

final modelValues = EnumValues({
    "borrow_book.borrow": Model.BORROW_BOOK_BORROW
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
