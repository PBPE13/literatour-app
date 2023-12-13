import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:literatour_app/profile/models/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Future<List<Profile>> fetchProfile() async {
    var url = Uri.parse('https://literatour-e13-tk.pbp.cs.ui.ac.id/profile-json/');
    var response = await http.get(
      url,
      headers: {"Access-Control-Allow-Origin": "*",
          "Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Profile> listProfile = [];
    for (var d in data) {
      if (d != null) {
        listProfile.add(Profile.fromJson(d));
      }
    }
    return listProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${profile.fields.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Role: ${profile.fields.role}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Bio: ${profile.fields.bioData}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text('Preferred Genre: ${profile.fields.preferredGenre}', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
