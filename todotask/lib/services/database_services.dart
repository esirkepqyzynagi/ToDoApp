import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todotask/model/todos_model.dart';

class DatabaseServices {
  final CollectionReference gorevCollection =
      FirebaseFirestore.instance.collection("gorevler");

  User? user = FirebaseAuth.instance.currentUser;
  //gorev ekle
  Future<DocumentReference> gorevEkle(String title, String subtitle) async {
    return await gorevCollection.add({
      'uid': user!.uid,
      'title': title,
      'subtitle': subtitle,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //gorevyenile
  Future<void> gorevYenile(String id, String title, String subtitle) async {
    final gorevyenileCollection =
        FirebaseFirestore.instance.collection("gorevler").doc(id);
    return await gorevyenileCollection.update({
      'title': title,
      'subtitle': subtitle,
    });
  }

  //gorevin durumu
  Future<void> gorevDurumuYenile(String id, bool completed) async {
    return await gorevCollection.doc(id).update({'completed': completed});
  }

  //gorevi silme
  Future<void> goreviSil(String id) async {
    return await gorevCollection.doc(id).delete();
  }

  //bekleyen gorevler
  Stream<List<Gorev>> get gorevler {
    return gorevCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_gorevListFromSnapshot);
  }

  //tamamlanan gorevler
  Stream<List<Gorev>> get completedgorevler {
    return gorevCollection
        .where('uid', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_gorevListFromSnapshot);
  }

  List<Gorev> _gorevListFromSnapshot(QuerySnapshot snaphot) {
    return snaphot.docs.map((doc) {
      return Gorev(
          id: doc.id,
          title: doc['title'] ?? '',
          subtitle: doc['subtitle'] ?? '',
          completed: doc['completed'] ?? false,
          timeStamp: doc['createdAt'] ?? '');
    }).toList();
  }
}
