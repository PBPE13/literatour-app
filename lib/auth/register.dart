import 'package:flutter/material.dart';
import 'package:literatour_app/auth/login.dart';
import 'package:literatour_app/home.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  String passwordConfirmation= "";
  String role = "Member";
  String genre = "";
  String fullname = "";
  String description = "";

  void _initRegister(request) async {
    final response = await request.post("https://literatour-e13-tk.pbp.cs.ui.ac.id/auth/registerFlutter/", {
      'role':role,
      'fullname':fullname,
      'genre':genre,
      'username':username,
      'password':password,
      'password2':passwordConfirmation,
      'description':description,
      
    }).then((value) {
      final newValue = new Map<String, dynamic>.from(value);
      setState(() {
        print(newValue['status'].toString() + "||||||||||||||||||||||||||||");
        if (newValue['status'].toString() == 'true') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Account has been successfully registered!"),
            backgroundColor: Colors.indigo,
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else if (newValue['status'].toString() == 'duplicate'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
            Text("Username already exist!"),
            backgroundColor: Colors.redAccent,
          ));
        } else if (newValue['status'].toString() == 'pass failed'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password does not match!"),
            backgroundColor: Colors.redAccent,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("An error occured, please try again."),
            backgroundColor: Colors.redAccent,
          ));
        }
      });
      
    });
 


  }

  @override
  Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  List<String> listRole = ['Member', 'Admin'];
  return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontFamily: "OpenSans",
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child : SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Welcome to Literatour",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color.fromARGB(178, 3, 3, 3),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                        title: const Text(
                          'Role', 
                        ),
                        trailing: DropdownButton(
                          value: role,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: listRole.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              role = newValue!;
                            });
                          },
                        ),
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          fullname = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          fullname = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Fullname cannot be empty!';
                        }
                        return null;
                      },
                      ),
                  ),
                  Padding( //Username
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Username",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                       onChanged: (String? value) {
                        setState(() {
                          username = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          username = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding( // Prefered Genre
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Preferred Genre",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                       onChanged: (String? value) {
                        setState(() {
                          genre = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          genre = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Fullname cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Short Description",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                       onChanged: (String? value) {
                        setState(() {
                          description = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          description = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Description cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                       onChanged: (String? value) {
                        setState(() {
                          password = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          password = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Repeat Password",
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                       onChanged: (String? value) {
                        setState(() {
                          passwordConfirmation = value!;
                        });},
                    // Menambahkan behavior saat data disimpan
                      onSaved: (String? value) {
                        setState(() {
                          passwordConfirmation = value!;
                        });
                      },
                      // Validator sebagai validasi form
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Fullname cannot be empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 3, 127, 230),
                        ),
                      ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _initRegister(request);
                      }
                    
                    },
                    
                ), ),
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginApp(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: const Color.fromARGB(255, 3, 127, 230)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailBookPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(color:  const Color.fromARGB(255, 3, 127, 230)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
     ))
  );}
}

