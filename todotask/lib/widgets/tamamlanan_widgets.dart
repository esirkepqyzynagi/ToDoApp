import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todotask/model/todos_model.dart';
import 'package:todotask/services/database_services.dart';

class TamamlananWidget extends StatefulWidget {
  const TamamlananWidget({super.key});

  @override
  State<TamamlananWidget> createState() => _TamamlananWidgetState();
}

class _TamamlananWidgetState extends State<TamamlananWidget> {
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
      stream: _databaseServices.completedgorevler,
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
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Slidable(
                  key: ValueKey(gorev.id),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
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
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text(
                      gorev.subtitle,
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
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
}
