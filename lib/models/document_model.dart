import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DocumentModel {
  final String title;
  final DateTime createdAt;
  final String uid;
  final List content;
  final String id;
  DocumentModel({
    required this.title,
    required this.createdAt,
    required this.uid,
    required this.content,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'uid': uid,
      'content': content,
      'id': id,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] as String ,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uid: map['uid'] as String,
      content: List.from(map['content']),
      id: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
