import 'package:flutter/material.dart';
import 'package:literatour_app/models/book.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
    const DetailBookPage({Key? key}) : super(key: key);

    @override
    _DetailBookPageState createState() => _DetailBookPageState();
}


class _DetailBookPageState extends State<DetailBookPage> {
  Future<List<Book>> fetchProduct() async {
      var url = Uri.parse(
          'http://localhost:8000/json/');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Product
      List<Book> listBook = [];
      for (var d in data) {
          if (d != null) {
              listBook.add(Book.fromJson(d));
          }
      }
      return listBook;
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
          title: const Text('Books'),
          backgroundColor:  Color(0xFF333333),
          foregroundColor: Colors.white,     
          ),
          body: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                  } else {
                      if (!snapshot.hasData) {
                      return const Column(
                          children: [
                          Text(
                              "Tidak ada data produk.",
                              style:
                                  TextStyle(color:Color(0xFF333333), fontSize: 20),
                          ),
                          SizedBox(height: 8),
                          ],
                      );
                  } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Card(
                            color:Colors.white,
                            elevation: 4.0,
                            margin: const EdgeInsets.all(8.0),
                           
                          ),
                        );
                  }
              }
          }) 
          ,bottomNavigationBar: BottomMenu(0),
          );
          
      }
}