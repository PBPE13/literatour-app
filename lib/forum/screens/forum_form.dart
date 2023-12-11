import 'dart:convert';

import 'package:literatour_app/forum/screens/forum.dart';
import 'package:literatour_app/main.dart';
import 'package:flutter/material.dart';
import 'package:literatour_app/forum/models/forum.dart';
import 'package:literatour_app/models/book.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literatour_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/widgets/bottom_menu.dart';
class ForumForm extends StatefulWidget {
  const ForumForm({super.key});
  @override
  State<ForumForm> createState() => _ForumFormState();
}

class _ForumFormState extends State<ForumForm> {
  final _formKey = GlobalKey<FormState>();
  String topic = "";
  DateTime? date = DateTime.now();
  String description = "";
  String title = "Harry Potter and the Half-Blood Prince (Harry Potter  #6)";
  List<String> listBookTitle = [];
  void _initSubmitForum(request) async {
    final response = await request.post("https://literatour-e13-tk.pbp.cs.ui.ac.id/forum/flutter/addForum/", {
      'topic': topic,
      'description': description,
      'title':title,
    }).then((value) {
      final newValue = new Map<String, dynamic>.from(value);
      setState(() {
        if (newValue['status'].toString() == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Success add forum!"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ForumPage()),
          );
        } else
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
            Text("Failed add forum"),
            backgroundColor: Colors.red,
          ));
      });
    });
  }
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Forum', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
          ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your topic",
                      labelText: "Topic",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.description),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // Menambahkan behavior saat nama diketik
                    onChanged: (String? value) {
                      setState(() {
                        topic = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        topic = value!;
                      });
                    },
                    // Validator sebagai validasi form
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Topic cannot be empty!';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your description",
                      labelText: "Description",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.title),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minLines: 10,
                    maxLines: 20,
                    // Menambahkan behavior saat nama diketik
                    onChanged: (String? value) {
                      setState(() {
                        description = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        description = value!;
                      });
                    },
                    // Validator sebagai validasi form
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Topic cannot be empty!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8), 
                FutureBuilder(
                  future: fetchBook(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              " :(",
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return InkWell(
                          child: Padding(
                            padding:const EdgeInsets.all(8.0),
                            child:Column( 
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children : [
                                const Text(
                                    'Book Title',
                                  ),
                                const SizedBox(width: 8), 
                              
                                DropdownButtonFormField(
                                  value: title,
                                  items: snapshot.data!.map<DropdownMenuItem<String>>((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item.length > 70? item.substring(0, 70): item,
                                      child: Text(item, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      title = newValue!;
                                    });},
                                  isExpanded: true,
                                  ),
                                  const SizedBox(width: 8), 
                                ]) 
                        ),);
                      }
                    }},),
                Padding(padding : EdgeInsets.only(top :20.0), 
                child: TextButton(
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 3, 127, 230))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _initSubmitForum(request);
                      }
                  },
                ),)
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(1),
    );
  }
}



