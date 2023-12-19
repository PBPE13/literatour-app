import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:literatour_app/models/book.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literatour_app/review/screens/review_page.dart';

class ReviewFormPage extends StatefulWidget {
  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBook;
  String content = '';
  int rating = 1;
  List<Book> books = [];

  @override
    void initState() {
      super.initState();
      fetchBooks();
    }
  Future<void> fetchBooks() async {
    var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/api/books/api/book/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      setState(() {
        books = bookFromJson(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Review'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedBook,
                  onChanged: (value) {
                    setState(() {
                      selectedBook = value;
                    });
                  },
                  items: books.map<DropdownMenuItem<String>>((Book book) {
                    return DropdownMenuItem<String>(
                      value: book.fields.title,
                      child: Text(book.fields.title),
                    );
                  }).toList(),
                  decoration: InputDecoration(labelText: 'Book Title'),
                  validator: (value) => value == null ? 'Please select a book' : null,
                ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Content'),
                onSaved: (value) => content = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review content';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: rating,
                items: [1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    rating = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (selectedBook == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please select a book")),
                        );
                        return;
                      }
                    final response = await request.postJson(
                      "https://literatour-e13-tk.pbp.cs.ui.ac.id/review/add-review-flutter/",
                      jsonEncode(<String, String>{
                        'book': selectedBook!,
                        'rating': rating.toString(),
                        'content': content,
                      }));
                      if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                          content: Text("Produk baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ReviewPage()),
                          );
                      } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content:
                                  Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                      }
                  }
                },
                child: const Text(
                      "Add Review",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
      ),
      bottomNavigationBar: BottomMenu(4),
    );
  }
}
