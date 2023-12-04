import 'dart:convert';
import 'package:literatour_app/forum/models/forum.dart';
import 'package:flutter/material.dart';
import 'package:literatour_app/forum/screens/forum.dart';
import 'package:literatour_app/forum/models/comment.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literatour_app/forum/screens/comment_form.dart';
import 'package:http/http.dart' as http;
import 'package:literatour_app/widgets/bottom_menu.dart';
class ForumDetailPage extends StatefulWidget {
  const ForumDetailPage({super.key, required this.myForum});
  final ForumPost myForum;
  @override
  State<ForumDetailPage> createState() => _ForumPostDetailState();
}

class _ForumPostDetailState extends State<ForumDetailPage> {

  @override
  Widget build(BuildContext context) {
    Future<List<Comment>> fetchComment(id) async {
        var url = Uri.parse('http://localhost:8000/forum/flutterComment/${id}/');
        var response = await http.get(
          url,
          headers: {
            "Access-Control-Allow-Origin":"*",
            "Content-Type": "application/json",
          },
        );
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        List<Comment> listComment = [];
        for (var comment in data) {
          if (comment != null) {
            listComment.add(Comment.fromJson(comment));
          }
        }
        return listComment;
      }
    
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 800,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.myForum.topic,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '${widget.myForum.description}\n'),
                        TextSpan(
                            text: '${widget.myForum.user}\n'),
                        TextSpan(
                            text: '${widget.myForum.date}\n'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForumPage()),
                      );
                    },
                    child: const SizedBox(
                        height: 40,
                        width: 200,
                        child: Center(
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                if (request.loggedIn)
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.indigo),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentForm(myForum:widget.myForum)),
                        );
                      },
                      child: const SizedBox(
                          height: 40,
                          width: 200,
                          child: Center(
                            child: Text(
                              "Add New Comment",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                      )
                  ),
                FutureBuilder<List<Comment>>(
                  future: fetchComment(widget),
                  builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            const Text(
                              "Oh no! Tidak ada forum :(",
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Container(
                              padding: const EdgeInsets.all(20.0),
                              height:150,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(17.0),
                              ),
                              child: Padding(
                                  padding:const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                              snapshot.data![index].date.toString(),
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              )
                                          ),
                                        ),
                                      ])
                              )
                          ),
                        );
                      }
                    }
                  },
                )
              ]),

            ],
          ),
        )
      ),
        bottomNavigationBar: BottomMenu(2),
    );
  }
}
