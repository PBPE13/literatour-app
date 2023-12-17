import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literatour_app/borrow/models/borrow.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BorrowPage extends StatefulWidget{
  const BorrowPage({super.key});

  @override
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage>{
  Future<List<Borrow>> fetchBorrow() async {
    var url = Uri.parse(
      'https://literatour-e13-tk.pbp.cs.ui.ac.id/borrow/get-borrow/');
    var response = await http.get(
          url,
          headers: {"Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Borrow> list_borrow = [];
    for (var d in data) {
      if (d != null) {
          list_borrow.add(Borrow.fromJson(d));
      }
    }
    return list_borrow;
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
        title: const Text('Borrow Book',
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
            } else if (!snapshot.hasData) {
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
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1 / 1.15,
                          ),
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  return InkWell(
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
                                            "${snapshot.data![index].fields.book.title}",
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text("${snapshot.data![index].fields.book.authors}"),
                                        const SizedBox(height: 5),
                                        Text("Borrow Date: ${snapshot.data![index].fields.borrow_date}"),
                                        const SizedBox(height: 5),
                                        Text("Return Date: ${snapshot.data![index].fields.return_date}")
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