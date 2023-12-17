import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:literatour_app/review/models/review.dart';
import 'package:literatour_app/review/screens/review_form.dart';
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  Future<List<Review>> fetchReviews() async {
    var url = Uri.parse('http://localhost:8000/review/get-review-json/');
    var response = await http.get(
      url, 
      headers: {"Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json"}
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
      ),
      body: FutureBuilder<List<Review>>(
        future: fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Review review = snapshot.data![index];
                return ListTile(
                  title: Text(review.fields.book),
                  subtitle: Text("Rated: ${review.fields.rating}/5"),
                  trailing: Text(review.fields.reviewDate.toLocal().toString()),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.all(8.0),
                  leading: CircleAvatar(child: Text(review.fields.user.toString())),
                  onTap: () {},
                );
              },
            );
          } else {
            return Center(child: Text("No reviews found"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewFormPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }
}
