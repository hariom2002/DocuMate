import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String email;
  final String name;
  final String token;
  final String uid;
  final String profilePic;
  UserModel({
    required this.email,
    required this.name,
    required this.token,
    required this.uid,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'token': token,
      'uid': uid,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
      uid: map['_id'] as String,
      profilePic: map['profilePhoto'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? email,
    String? name,
    String? token,
    String? uid,
    String? profilePic,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
    );
  }
}
