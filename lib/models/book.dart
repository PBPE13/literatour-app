// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    Model model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
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
    int bookId;
    String title;
    String authors;
    double averageRating;
    String isbn;
    int isbn13;
    LanguageCode languageCode;
    int numPages;
    int ratingsCount;
    int textReviewCount;
    String publicationDate;
    String publisher;
    bool status;

    Fields({
        required this.bookId,
        required this.title,
        required this.authors,
        required this.averageRating,
        required this.isbn,
        required this.isbn13,
        required this.languageCode,
        required this.numPages,
        required this.ratingsCount,
        required this.textReviewCount,
        required this.publicationDate,
        required this.publisher,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        bookId: json["bookID"],
        title: json["title"],
        authors: json["authors"],
        averageRating: json["average_rating"]?.toDouble(),
        isbn: json["isbn"],
        isbn13: json["isbn13"],
        languageCode: languageCodeValues.map[json["language_code"]]!,
        numPages: json["num_pages"],
        ratingsCount: json["ratings_count"],
        textReviewCount: json["text_review_count"],
        publicationDate: json["publication_date"],
        publisher: json["publisher"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "bookID": bookId,
        "title": title,
        "authors": authors,
        "average_rating": averageRating,
        "isbn": isbn,
        "isbn13": isbn13,
        "language_code": languageCodeValues.reverse[languageCode],
        "num_pages": numPages,
        "ratings_count": ratingsCount,
        "text_review_count": textReviewCount,
        "publication_date": publicationDate,
        "publisher": publisher,
        "status": status,
    };
}

enum LanguageCode {
    ENG,
    EN_US,
    FRE
}

final languageCodeValues = EnumValues({
    "eng": LanguageCode.ENG,
    "en-US": LanguageCode.EN_US,
    "fre": LanguageCode.FRE
});

enum Model {
    BOOK_BOOK
}

final modelValues = EnumValues({
    "book.book": Model.BOOK_BOOK
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
