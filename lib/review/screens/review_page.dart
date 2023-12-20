import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:literatour_app/review/models/review.dart';
import 'package:literatour_app/review/screens/review_form.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import "package:literatour_app/user/user_provider.dart";

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review>? reviews;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    var fetchedReviews = await fetchReviews();
    setState(() {
      reviews = fetchedReviews;
    });
  }

  Future<List<Review>> fetchReviews() async {
    var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/review/get-review-json/');
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
  Future<void> _deleteReview(CookieRequest request, Review review) async {
    final response = await request.postJson(
      "https://literatour-e13-tk.pbp.cs.ui.ac.id/review/delete-review-flutter/${review.pk}/",
      jsonEncode({}),
    );

    if (response['status'] == 'success') {
      await _loadReviews();
      if(!context.mounted) return;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Successful"),
            content: const Text("Your review has been deleted successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Delete failed. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
     final userID = Provider.of<UserProvider>(context).user?.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,      
      ),
      body: FutureBuilder<List<Review>>(
        future: reviews != null ? Future.value(reviews) : fetchReviews(),
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
                bool isCurrentUser = (userID == review.fields.user);
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(review.fields.book),
                    subtitle: Text("Rated: ${review.fields.rating}/5"),
                    trailing: isCurrentUser ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _deleteReview(request, review);
                      },
                    ) : Text(review.fields.reviewDate.toLocal().toString()),
                    isThreeLine: true,
                    contentPadding: EdgeInsets.all(8.0),
                    leading: CircleAvatar(child: Text(review.fields.user.toString())),
                    onTap: () {},
                  ),
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
      bottomNavigationBar: BottomMenu(4),
    );
    
  }
  
}
