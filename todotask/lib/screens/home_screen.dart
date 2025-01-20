import 'package:flutter/material.dart';
import 'package:todotask/model/todos_model.dart';
import 'package:todotask/screens/login_screen.dart';
import 'package:todotask/services/auth_services.dart';
import 'package:todotask/services/database_services.dart';
import 'package:todotask/widgets/bekleyen_widgets.dart';
import 'package:todotask/widgets/tamamlanan_widgets.dart';

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  int _buttonIndex = 0;

  final _widgets = [
    //bekleyen gorevler
    BekleyenWidget(),
    //tamamlanan gorevler
    TamamlananWidget(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text('Görevler'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => GirisEkrani()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 0 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Bekleyen',
                        style: TextStyle(
                          fontSize: _buttonIndex == 0 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 0 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _buttonIndex == 1 ? Colors.indigo : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Tamamlanan',
                        style: TextStyle(
                          fontSize: _buttonIndex == 1 ? 16 : 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 1 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _showTaskDialog(context);
        },
      ),
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
