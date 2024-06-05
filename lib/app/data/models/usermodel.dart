import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? photoUrl;
  String? email;
  String? roles;
  String? noKTP;
  String? username;
  String? namaLengkap;
  String? nomorTelepon;
  String? alamat;

  UserModel({
    this.uid,
    this.photoUrl,
    this.email,
    this.roles,
    this.noKTP,
    this.username,
    this.namaLengkap,
    this.nomorTelepon,
    this.alamat,
  });

  factory UserModel.fromJson(DocumentSnapshot data) {
    final json = data.data() as Map<String, dynamic>;
    return UserModel(
      uid: json['uid'],
      photoUrl: json['photoUrl'],
      email: json['email'],
      roles: json['roles'],
      noKTP: json['noKTP'],
      username: json['username'],
      namaLengkap: json['namaLengkap'],
      nomorTelepon: json['nomorTelepon'],
      alamat: json['alamat'],
    );
  }
}

class UserSQLModel {
  int? idUser;
  String? uid;
  String? photoUrl;
  String? email;
  String? noKTP;
  String? username;
  String? namaLengkap;
  String? nomorTelepon;
  String? alamat;

  UserSQLModel({
    this.idUser,
    this.uid,
    this.photoUrl,
    this.email,
    this.noKTP,
    this.username,
    this.namaLengkap,
    this.nomorTelepon,
    this.alamat,
  });

  factory UserSQLModel.fromJson(Map<String, dynamic> json) {
    return UserSQLModel(
      idUser: json['id_user'],
      uid: json['uid'],
      photoUrl: json['foto_url'],
      email: json['email'],
      noKTP: json['no_ktp'],
      username: json['username'],
      namaLengkap: json['nama_lengkap'],
      nomorTelepon: json['no_telp'],
      alamat: json['alamat'],
    );
  }
}
