import 'package:flutter/material.dart';
import 'package:literatour_app/diary/models/diary.dart';
import 'package:literatour_app/diary/widgets/left_drawer.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  Future<List<Diary>> fetchDiary() async {
    final request = context.watch<CookieRequest>();
    final response = await request
        .get('https://literatour-e13-tk.pbp.cs.ui.ac.id/diary/get-diary/');

    List<Diary> list_product = [];
    for (var d in response) {
      if (d != null) {
        list_product.add(Diary.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diary')),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchDiary(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData) {
                return const Column(
                  children: [
                    Text(
                      "Tidak ada diary.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${snapshot.data![index].fields.title}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.finishDate}"),
                          const SizedBox(height: 10),
                          Text("${snapshot.data![index].fields.notes}")
                        ],
                      ),
                    ),
                  ),
                );
              }
            }
          }),
      bottomNavigationBar: BottomMenu(3),
    );
  }
}
