import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literatour_app/auth/login.dart';
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
          title: const Text('Forum', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
          ),
        
        body: Stack(
          children: [
          SingleChildScrollView(
            child:
              Column (
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                    Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                            builder: (context) => ForumDetailPage(
                                              myForum:snapshot.data![index])),);
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(top:8.0, left: 15.0, right: 15.0, bottom: 18.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![index].topic,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Mulish',
                                                  )
                                                ),
                                                Text(
                                                  snapshot.data![index].title,
                                                  overflow: TextOverflow.fade,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Mulish',
                                                  )
                                                ),
                                                Text(
                                                  snapshot.data![index].description,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      overflow: TextOverflow.visible,
                                                      fontStyle: FontStyle.italic,
                                                      fontFamily: 'Mulish',
                                                    )
                                                  ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: 
                                                  Text(
                                                        "by: " + snapshot.data![index].user,
                                                        overflow: TextOverflow.fade,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Mulish',
                                                        )
                                                    ),
                                                  ),
                                                  Text(
                                                      snapshot.data![index].date.toString(),
                                                      overflow: TextOverflow.fade,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: 'Mulish',
                                                      )
                                                  ),
                                              ])
                                              )
                                  ),
                                ));}
                        }},)])), 
              Positioned(
                  bottom: MediaQuery.of(context).size.height / 48,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForumForm(),
                      ));
                    },
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: const Color.fromARGB(255, 3, 127, 230),
                    shape: CircleBorder(),
                  ),
                ),
              ])
        ,bottomNavigationBar: BottomMenu(1),
    );
  }
  
}
