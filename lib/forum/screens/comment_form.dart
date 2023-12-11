import 'package:literatour_app/forum/models/forum.dart';
import 'package:literatour_app/main.dart';
import 'package:flutter/material.dart';
import 'package:literatour_app/forum/models/forum.dart';
import 'package:literatour_app/forum/screens/forum_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literatour_app/main.dart';
import 'package:provider/provider.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
class CommentForm extends StatefulWidget {
  const CommentForm({super.key, required this.myForum});
  final ForumPost myForum;
  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {

  final _formKey = GlobalKey<FormState>();
  String description = "";
  void _initSubmitComment(request) async {
    final response = await request.post("https://literatour-e13-tk.pbp.cs.ui.ac.id/forum/flutter/addComment/${widget.myForum.pk}/", {
      'description': description,
    }).then((value) {
      final newValue = new Map<String, dynamic>.from(value);
      setState(() {
        if (newValue['status'].toString() == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Success add comment!"),
            backgroundColor: Colors.indigo,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ForumDetailPage(myForum:widget.myForum)),
          );
        } else
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
            Text("Failed add comment"),
            backgroundColor: Colors.redAccent,
          ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
    appBar: AppBar(
          title: const Text('Add Comment', 
            style: const TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,     
          ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your comment",
                      labelText: "Comment",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.description),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minLines: 5,
                    maxLines: 20,
                    // Menambahkan behavior saat nama diketik
                    onChanged: (String? value) {
                      setState(() {
                        description = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        description = value!;
                      });
                    },
                    // Validator sebagai validasi form
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Topic cannot be empty!';
                      }
                      return null;
                    },
                  ),
                ),
                TextButton(
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all( const Color.fromARGB(255, 3, 127, 230)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _initSubmitComment(request);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),bottomNavigationBar: BottomMenu(1),
    );
  }
}
