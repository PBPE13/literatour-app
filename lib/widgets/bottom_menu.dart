import 'package:flutter/material.dart';
import 'package:literatour_app/auth/login.dart';
import 'package:literatour_app/forum/screens/forum.dart';
import 'package:literatour_app/forum/screens/forum_detail.dart';
import 'package:literatour_app/forum/screens/forum_form.dart';
import 'package:literatour_app/home.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BottomMenu extends StatelessWidget {
  final int menuIndex;

  BottomMenu(this.menuIndex);

  BottomNavigationBarItem getItem(
    IconData icon, String title, int index) {
    return BottomNavigationBarItem(
      label: title,
      icon: Icon(
        icon,
        size: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final request = context.watch<CookieRequest>();
    List<BottomNavigationBarItem> menuItems = [
      getItem(Icons.home, 'Home',  0),
      getItem(Icons.chat_bubble, 'Forum',  1),
      getItem(Icons.local_library, 'Borrow',  2),
      getItem(Icons.book, 'Diary', 3),
      getItem(Icons.face, 'Profile', 4),
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: menuIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DetailBookPage()));
                break;
              case 1:
                if (!request.loggedIn){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                }else {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ForumPage()));
                }
                break;
              case 2:
                
                break;
              case 3:
              
                break;
              case 4:
               
                break;
            }
          },
          items: menuItems,
        ),
      ),
    );
  }
}
