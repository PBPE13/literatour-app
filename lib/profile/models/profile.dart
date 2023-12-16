import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    String model;
    int pk;
    Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
    String role;
    String name;
    String bioData;
    String preferredGenre;

    Fields({
        required this.user,
        required this.role,
        required this.name,
        required this.bioData,
        required this.preferredGenre,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        role: json["role"],
        name: json["name"],
        bioData: json["bio_data"],
        preferredGenre: json["preferred_genre"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "role": role,
        "name": name,
        "bio_data": bioData,
        "preferred_genre": preferredGenre,
    };
}
