import 'package:flutter/material.dart';
import 'package:literatour_app/home.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:literatour_app/user/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) {
          CookieRequest request = CookieRequest();
          return request;
        }),
      ],
      child: MaterialApp(
        title: 'Literatour',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 11, 127, 222)),
          useMaterial3: true,
        ),
        home: const DetailBookPage(),
      ),
    );
  }
}
