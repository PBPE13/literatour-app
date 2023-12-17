import 'package:flutter/material.dart';
import 'package:literatour_app/diary/screens/diary_page.dart';
import 'package:literatour_app/diary/screens/diary_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SizedBox(
              height: 40,
              child: Column(
                children: [
                  Text(
                    'Diary',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book_sharp),
            title: const Text('Your Diary Page'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiaryPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_box_outlined),
            title: const Text('Add A New Diary'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiaryFormPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
