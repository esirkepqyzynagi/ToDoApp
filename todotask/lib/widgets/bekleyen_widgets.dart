import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todotask/model/todos_model.dart';
import 'package:todotask/services/database_services.dart';

class BekleyenWidget extends StatefulWidget {
  const BekleyenWidget({super.key});

  @override
  State<BekleyenWidget> createState() => _BekleyenWidgetState();
}

class _BekleyenWidgetState extends State<BekleyenWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  late String uid;

  final DatabaseServices _databaseServices = DatabaseServices();

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Gorev>>(
      stream: _databaseServices.gorevler,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Gorev> gorevler = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: gorevler.length,
            itemBuilder: (context, index) {
              Gorev gorev = gorevler[index];
              final DateTime zaman = gorev.timeStamp.toDate();
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(gorev.id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black,
                          icon: Icons.done,
                          label: "Tamamla",
                          onPressed: (context) {
                            _databaseServices.gorevDurumuYenile(gorev.id, true);
                          })
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          icon: Icons.edit,
                          label: "Düzenle",
                          onPressed: (context) {
                            _showTaskDialog(context, gorev: gorev);
                          }),
                      SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black,
                          icon: Icons.delete,
                          label: "Sil",
                          onPressed: (context) async {
                            await _databaseServices.goreviSil(gorev.id);
                          })
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      gorev.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      gorev.subtitle,
                    ),
                    trailing: Text(
                      '${zaman.day}/${zaman.month}/${zaman.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }
      },
    );
  }

  void _showTaskDialog(BuildContext context, {Gorev? gorev}) {
    final TextEditingController _titleController =
        TextEditingController(text: gorev?.title);
    final TextEditingController _subtitleController =
        TextEditingController(text: gorev?.subtitle);
    final DatabaseServices _databaseServices = DatabaseServices();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            gorev == null ? "Görev Ekle" : "Düzenle",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Başlık",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      labelText: "Açıklama",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (gorev == null) {
                  await _databaseServices.gorevEkle(
                      _titleController.text, _subtitleController.text);
                } else {
                  await _databaseServices.gorevYenile(gorev.id,
                      _titleController.text, _subtitleController.text);
                }
                Navigator.pop(context);
              },
              child: Text(gorev == null ? "Ekle" : "Yenile"),
            ),
          ],
        );
      },
    );
  }
}
