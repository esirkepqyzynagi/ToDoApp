import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Giris
  Future<User?> signInWithEmailAndPassword(String ePosta, String sifre) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: ePosta, password: sifre);
      User? kullanici = result.user;
      return kullanici;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Kayit
  Future<User?> registerWithEmailAndPassword(
      String ePosta, String sifre) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: ePosta, password: sifre);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Cikis
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
