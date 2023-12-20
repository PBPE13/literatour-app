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
  String selectedBook = 'Harry Potter and the Half-Blood Prince (Harry Potter  #6)';
  String content = '';
  int rating = 1;
  List<String> books = [];

  Future<List<String>>  fetchBook()  async {
    var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/json/');
    var response = await http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin":"*",
        "Content-Type": "application/json",
      },
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<String> listBook = [];
    for (var book in data) {
      if (book != null) {
        listBook.add(Book.fromJson(book).fields.title);
      }
    }
    return listBook;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Review', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,   
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: fetchBook(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (!snapshot.hasData) {
                          return Column(
                            children: [
                              Text(
                                "Book list is empty !",
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        } else {
                          return InkWell(
                            child: Column( 
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children : [
                                const Text(
                                    'Book Title',
                                  ),
                                const SizedBox(width: 8), 
                              
                                DropdownButtonFormField(
                                  value: selectedBook,
                                  items: snapshot.data!.map<DropdownMenuItem<String>>((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item.length > 70? item.substring(0, 70): item,
                                      child: Text(item, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedBook = newValue!;
                                    });},
                                  isExpanded: true,
                                  ),
                                  const SizedBox(width: 8), 
                                ]),);
                        }
                      }},),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Content'),
                  onSaved: (value) => content = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your review content';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField(
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
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
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
