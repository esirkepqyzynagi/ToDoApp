import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todotask/screens/home_screen.dart';
import 'package:todotask/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TODO",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: _auth.currentUser != null ? AnaEkran() : GirisEkrani(),
    );
  }
}
