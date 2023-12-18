import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literatour_app/borrow/screens/book_list.dart';
import 'package:literatour_app/models/book.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DetailItemPage extends StatefulWidget {
    final Book book;

    const DetailItemPage({super.key, required this.book});

    @override
    State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Book', 
          style: TextStyle(
            fontFamily: "OpenSans",
            fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Title: ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.book.fields.title,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Book ID: ${widget.book.fields.bookId}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Author: ${widget.book.fields.authors}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Average Rating: ${widget.book.fields.averageRating}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Language Code: ${widget.book.fields.languageCode}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Publication Date: ${widget.book.fields.publicationDate}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Publisher: ${widget.book.fields.publisher}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              widget.book.fields.status
                  ? 'Status Buku: Buku Tersedia'
                  : 'Status Buku: Buku Tidak Tersedia',
              style: const TextStyle(fontSize: 18),
            ),
            Visibility(
              visible: widget.book.fields.status,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Builder(
                  builder: (context) {
                    final buttonWidth = MediaQuery.of(context).size.width / 2;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.all(16.0),
                        minimumSize: Size(buttonWidth, 50),
                      ),
                      onPressed: () {
                        showDialog(
                          context:context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Tanggal Pengembalian Buku"),
                              content: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        controller: _date,
                                        decoration: InputDecoration(
                                          hintText: "year-month-day",
                                          labelText: "Return Date", 
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return "Tanggal pengembalian tidak boleh kosong!";
                                          }
                                          return null;
                                        },
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            child: const Text("Pinjam Buku"),
                                            onPressed: () async {
                                              if (_formKey.currentState!.validate()){
                                                final response = await request.postJson("https://literatour-e13-tk.pbp.cs.ui.ac.id/borrow/borrow-flutter/${widget.book.pk}/",
                                                jsonEncode(<String, String>{
                                                  'return_date' : _date.text,
                                                }));
                                                if(response['status'] == 'success'){
                                                  // ignore: use_build_context_synchronously
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(const SnackBar(
                                                      content: Text("Berhasil Meminjam buku")));
                                                  
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const BookListPage()),
                                                  );
                                                } else{
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(const SnackBar(
                                                      content: Text("Tidak dapat Meminjam buku. Silahkan coba lagi")));
                                                }
                                              }
                                            },
                                          )
                                        ]
                                      )
                                    ]
                                  )
                                )
                              ),
                            );
                          }
                        ); 
                      },
                      child: const Text(
                        'Borrow Book',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            )  
          ],
        )
      )
    );
  }
}