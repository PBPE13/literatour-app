import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literatour_app/borrow/models/borrow.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/models/book.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BorrowPage extends StatefulWidget{
  const BorrowPage({super.key});

  @override
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage>{
  Map<Book, Borrow> borrowedBooks = {};

  Future<Map<Book, Borrow>> fetchBorrow() async {
    var url = Uri.parse(
      'https://literatour-e13-tk.pbp.cs.ui.ac.id/borrow/get-borrow-flutter/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    Map<Book, Borrow> list_borrow = {};
    if (data != null) {
      for (var d in data) {
        if (d != null) {
          int bookId = Borrow.fromJson(d).fields.book;
          Book book = await fetchBookById(bookId);
          Borrow borrow = Borrow.fromJson(d);
          list_borrow.addAll({book : borrow});
        }
     }
    }
    return list_borrow;
  }

  Future<Book> fetchBookById(int id) async {
    var url = Uri.parse(
      'https://literatour-e13-tk.pbp.cs.ui.ac.id/borrow/get-book-by-id/$id');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      return Book.fromJson(
        data[0]);
    } else {
      throw Exception(
        'Error!. Status code: ${response.statusCode}'
      );
    }
  }

  @override
  Widget build(BuildContext context) {  
    final request = context.watch<CookieRequest>();
    double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth > 1200) {
        crossAxisCount = 3;
    } else if (screenWidth > 600) {
        crossAxisCount = 2;
    } else {
        crossAxisCount = 1;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrowed Book',
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, 
        ),
        body: FutureBuilder(
          future: fetchBorrow(),
          builder:(context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            }else if (!snapshot.hasData) {
              return const Column(
                  children: [
                    Text(
                      "Anda belum meminjam buku.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                  ],
                );
            }else{
              borrowedBooks = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 / 1.15,
                ),
                itemCount: borrowedBooks.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () async {
                      final response = await request.postJson('https://literatour-e13-tk.pbp.cs.ui.ac.id/return-book-flutter/${borrowedBooks.values.elementAt(index).pk}/',
                        jsonEncode(<String, String>{
                          'bookId': borrowedBooks.keys.elementAt(index).pk.toString(),
                        }),
                      );

                      if(response['status'] == 'succes'){
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text("Berhasil mengembalikan buku")));
                        
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BorrowPage()),
                        );
                      } else{
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                            content: Text("Tidak dapat mengembalikan buku. Silahkan coba lagi")));
                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)), 
                            child: AspectRatio(
                              aspectRatio: 1.5,
                              child: Image.network(
                                  'https://images.saymedia-content.com/.image/t_share/MTc0MjYyNTc5Mjg2MjU1MTAw/10-books-over-1000-pages-to-read.jpg',
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            borrowedBooks.keys.elementAt(index).fields.title,
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(borrowedBooks.keys.elementAt(index).fields.authors),
                                        const SizedBox(height: 5),
                                        Text("Borrow Date: ${borrowedBooks.values.elementAt(index).fields.borrowDate}"),
                                        const SizedBox(height: 5),
                                        Text("Return Date: ${borrowedBooks.values.elementAt(index).fields.returnDate}")
                                    ],
                                ),
                            ),
                        ),
                        ]
                      )
                    )
                  );
                }
              );
            }
          }
        ),bottomNavigationBar: BottomMenu(2),
    );
  }
}