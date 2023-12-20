import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literatour_app/profile/models/profile.dart';
import 'package:literatour_app/home.dart';
import 'package:literatour_app/widgets/bottom_menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literatour_app/user/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Profile>> fetchProfile() async {
    final userID = Provider.of<UserProvider>(context).user?.id;
    var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/profile-json/');
    var response = await http.get(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json"
      },
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Profile> listProfile = [];
    for (var d in data) {
      if (d != null && d['fields']['user'] == userID) {
        listProfile.add(Profile.fromJson(d));
      }
    }
    return listProfile;
  }
  String getRoleDisplayName(String role) {
    if (role == 'M') {
      return 'Member';
    } else if (role == 'A') {
      return 'Admin';
    } else {
      return 'Unknown Role';
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: const TextStyle(
              fontFamily: "OpenSans", fontWeight: FontWeight.w800)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Profile>>(
        future: fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No profile data available"));
          } else {
            Profile profile = snapshot.data!.first;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/6915/6915987.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${profile.fields.name}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Role: ${getRoleDisplayName(profile.fields.role)}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Bio: ${profile.fields.bioData}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Preferred Genre: ${profile.fields.preferredGenre}',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final response = await request.logout(
                              "https://literatour-e13-tk.pbp.cs.ui.ac.id/auth/logout/");
                          String message = response["message"];
                          if (response['status']) {
                            String uname = response["username"];
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("$message Sampai jumpa, $uname."),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DetailBookPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                            ));
                          }
                        },
                        child: const Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ), bottomNavigationBar: BottomMenu(5),
    );
  }
}
