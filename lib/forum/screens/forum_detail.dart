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
        var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/forum/flutterComment/${widget.myForum.pk}/');
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
          title: const Text('Detail Forum', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
          ),
      body: Stack( 
        children: [
          SingleChildScrollView(
                child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom:20), 
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.myForum.topic,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mulish',
                            )
                          ),
                          Text(
                            widget.myForum.title,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                            )
                          ),
                          Text(
                            widget.myForum.description,
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
                                    "by: " + widget.myForum.user,
                                    overflow: TextOverflow.fade,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Mulish',
                                    )
                                ),
                              ),
                          Text(
                              widget.myForum.date.toString(),
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Mulish',
                              )
                          )
                        ]
                      ),),
                   
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                itemBuilder: (_, index) => 
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0, left: 20.0, right: 15.0, bottom: 20.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: 
                                          BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.grey, width: 0.3),
                                          borderRadius: BorderRadius.circular(10.0),
                                          
                                        ),                       child: 
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
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
                                                        overflow: TextOverflow.clip,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Mulish',
                                                        )
                                                    ),
                                              ),
                                              Text(
                                                  snapshot.data![index].date.toString(),
                                                  overflow: TextOverflow.clip,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Mulish',
                                                  )
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
          Positioned(
                bottom: MediaQuery.of(context).size.height / 48,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentForm(myForum: widget.myForum),
                    ));
                  },
                  child: Icon(Icons.chat_bubble, color: Colors.white),
                  backgroundColor: const Color.fromARGB(255, 3, 127, 230),
                  shape: CircleBorder(),
                ),
              ),
        ]
      ), 
      bottomNavigationBar: BottomMenu(1),
    );
  }
}
