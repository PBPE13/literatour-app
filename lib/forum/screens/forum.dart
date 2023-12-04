import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literatour_app/forum/models/forum.dart';
import 'package:literatour_app/forum/screens/forum_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literatour_app/forum/screens/forum_form.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/widgets/bottom_menu.dart';
class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<ForumPost>>  fetchForum()  async {
  var url = Uri.parse('http://localhost:8000/forum/flutterForum/');
  var response = await http.get(
    url,
    headers: {
      "Access-Control-Allow-Origin":"*",
      "Content-Type": "application/json",
    },
  );
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  List<ForumPost> listForum = [];
  for (var forum in data) {
    if (forum != null) {
      listForum.add(ForumPost.fromJson(forum));
    }
  }
  return listForum;
}
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text ("ForumPost"),
      ),
        body: SingleChildScrollView(
          child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (request.loggedIn)
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForumForm()),
                        );
                      },
                      child: const SizedBox(
                          height: 40,
                          width: 200,
                          child: Center(
                            child: Text(
                              "Add New ForumPost",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                      )
                  ),
                FutureBuilder(
                  future: fetchForum(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            Text(
                              "Oh no! Tidak ada forum :(",
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => InkWell(
                              // make anything clickable
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForumDetailPage(
                                          myForum:snapshot.data![index])),
                                );
                              },
                              child: Padding(
                                  padding:const EdgeInsets.all(8.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(20),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(17.0),
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  snapshot.data![index].topic,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                  )
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  snapshot.data![index].description,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  )
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  "written by " + snapshot.data![index].user,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  )
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  snapshot.data![index].title,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  )
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                  snapshot.data![index].date.toString(),
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  )
                                              ),
                                            ),
                                          ]))
                              )
                              ,
                            ));
                      }
                    }
                  },
                )
              ]
          )
        )

     ,bottomNavigationBar: BottomMenu(2),
    );
  }
}
