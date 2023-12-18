import 'package:flutter/material.dart';
import 'package:literatour_app/models/book.dart';

class DetailItemPage extends StatefulWidget {
    final Book book;

    const DetailItemPage({super.key, required this.book});

    @override
    State<DetailItemPage> createState() => _DetailItemPageState();
}

class _DetailItemPageState extends State<DetailItemPage> {
  @override
  Widget build(BuildContext context) {
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
                        // 
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