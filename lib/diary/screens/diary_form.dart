import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literatour_app/diary/widgets/left_drawer.dart';
import 'package:literatour_app/diary/screens/diary_page.dart';
import 'package:literatour_app/models/book.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DiaryFormPage extends StatefulWidget {
  const DiaryFormPage({super.key});

  @override
  State<DiaryFormPage> createState() => _DiaryFormPageState();
}

class _DiaryFormPageState extends State<DiaryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  DateTime? _finishDate = DateTime.now();
  String _notes = "";
  late Future<List<String>> _books;

  @override
  void initState() {
    super.initState();
    _books = fetchAllBooks();
  }

  Future<List<String>> fetchAllBooks() async {
    final request = context.read<CookieRequest>();
    final response =
        await request.get('https://literatour-e13-tk.pbp.cs.ui.ac.id/json/');

    List<String> listBook = [];
    for (var d in response) {
      if (d != null) {
        listBook.add(Book.fromJson(d).fields.title);
      }
    }
    return listBook;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Diary',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: _books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No books available');
                  } else {
                    if (!snapshot.data!.contains(_title)) {
                      _title = snapshot.data![0];
                    }

                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Select Book Title",
                        labelText: "Book Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      value: _title,
                      items: snapshot.data!.map((String book) {
                        return DropdownMenuItem<String>(
                          value: book,
                          child: Text(book),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _title = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Title cannot be empty!";
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    // update sesuai pilihan
                    setState(() {
                      _finishDate = selectedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _finishDate != null
                      ? "${_finishDate!.year}-${_finishDate!.month}-${_finishDate!.day}"
                      : "",
                ),
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Finish Date",
                  labelText: "Finish Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Finish date cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Notes",
                  labelText: "Notes",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _notes = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Notes cannot be empty!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Kirim ke Django dan tunggu respons
                        final response = await request.postJson(
                            "https://literatour-e13-tk.pbp.cs.ui.ac.id/diary/create-diary-flutter/",
                            jsonEncode(<String, String>{
                              'title': _title,
                              'finishDate': _finishDate.toString(),
                              'notes': _notes,
                            }));

                        print("Raw Response from server: $response");

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Succeeded on saving a new diary!"),
                          ));

                          // Only navigate if the request is successful
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DiaryPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                      } catch (error) {
                        // Handle errors here, if any
                        print("Error: $error");
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: BottomMenu(3),
    );
  }
}