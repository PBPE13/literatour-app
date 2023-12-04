import 'package:literatour_app/forum/screens/forum.dart';
import 'package:literatour_app/main.dart';
import 'package:flutter/material.dart';
import 'package:literatour_app/forum/models/forum.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literatour_app/main.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
class ForumForm extends StatefulWidget {
  const ForumForm({super.key});
  @override
  State<ForumForm> createState() => _ForumFormState();
}

class _ForumFormState extends State<ForumForm> {
  final _formKey = GlobalKey<FormState>();
  String topic = "";
  DateTime? date = DateTime.now();
  String description = "";
  void _initSubmitForum(request) async {
    final response = await request.post("http:/localhost:8000/forum/flutter/addForum/", {
      'topic': topic,
      'description': description,
    }).then((value) {
      final newValue = new Map<String, dynamic>.from(value);
      setState(() {
        if (newValue['status'].toString() == "success") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Success add forum!"),
            backgroundColor: Colors.green,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ForumPage()),
          );
        } else
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
            Text("Failed add forum"),
            backgroundColor: Colors.red,
          ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Forum'),
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
                      hintText: "Enter your topic",
                      labelText: "Topic",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.description),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // Menambahkan behavior saat nama diketik
                    onChanged: (String? value) {
                      setState(() {
                        topic = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        topic = value!;
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
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Enter your description",
                      labelText: "Description",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.title),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    minLines: 10,
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
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _initSubmitForum(request);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(2),
    );
  }
}