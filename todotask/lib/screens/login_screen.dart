import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotask/screens/home_screen.dart';
import 'package:todotask/screens/signup_screen.dart';
import 'package:todotask/services/auth_services.dart';

class GirisEkrani extends StatelessWidget {
  final AuthServices _auth = AuthServices();
  final TextEditingController _ePostaController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text('Giriş Yap'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 50),
              Text(
                "Hoş geldiniz",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                "Buradan Giriş Yapın",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              SizedBox(height: 35),
              TextField(
                controller: _ePostaController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "E-posta",
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 25),
              TextField(
                controller: _sifreController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Sifre",
                    labelStyle: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      User? user = await _auth.signInWithEmailAndPassword(
                        _ePostaController.text,
                        _sifreController.text,
                      );
                      if (user != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnaEkran(),
                            ));
                      }
                    },
                    child: Text(
                      "Kayıt ol",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                      ),
                    )),
              ),
              SizedBox(height: 35),
              Text(
                'VEYA',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KayitEkrani(),
                        ));
                  },
                  child: Text(
                    'Hesap Oluştur',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
