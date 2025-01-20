import 'package:cloud_firestore/cloud_firestore.dart';

class Gorev {
  final String id;
  final String title;
  final String subtitle;
  final bool completed;
  final Timestamp timeStamp;

  Gorev(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.completed,
      required this.timeStamp});
}
