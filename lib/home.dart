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
  TextEditingController searchController = TextEditingController();
  List<Book> filteredBooks = [];
  List<Book> listBook = [];

  Future<List<Book>> fetchProduct() async {
      var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/api/books/api/book/');
      var response = await http.get(
          url,
          headers: {"Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json"},
      );

      var data = jsonDecode(utf8.decode(response.bodyBytes));

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
          title: const Text('Literatour', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search",
                    prefixIcon: const Icon(Icons.search),
                    hintText:"Search books ...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onChanged: (value){
                    setState(() {
                      filteredBooks = listBook.where((element){
                        return element.fields.title.toLowerCase().contains(value.toLowerCase());
                      }).toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: fetchProduct(),
                  builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                          return const Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                          return const Center(
                              child: Text(
                                  "Tidak ada data produk.",
                                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                              ),
                          );
                      } else {
                        listBook = snapshot.data;
                        List<Book> displayedBook = searchController.text.isEmpty
                          ? listBook
                          : filteredBooks;
                          return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1 / 1.15,
                              ),
                              itemCount: displayedBook.length,
                              itemBuilder: (_, index) {
                                  Book book = displayedBook[index];
                                  return InkWell(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                    ),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                  ClipRRect(
                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)), // Rounded corners for the top of the image
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
                                                                      displayedBook[index].fields.title,
                                                                      style: const TextStyle(
                                                                          fontSize: 20.0,
                                                                          fontWeight: FontWeight.bold,
                                                                      ),
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  Text(displayedBook[index].fields.authors),
                                                                  const SizedBox(height: 5),
                                                                  Text("${displayedBook[index].fields.averageRating}")
                                                              ],
                                                          ),
                                                      ),
                                                  ),
                                              ],
                                          ),
                                      ),
                                  );
                              },
                          );
                      }
                  },
                ),
              )
            ],
          ),bottomNavigationBar: BottomMenu(0),
        );  
      }
}