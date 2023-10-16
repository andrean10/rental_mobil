import 'package:cloud_firestore/cloud_firestore.dart';

class PenyewaanModel {
  final String? uid;
  final UsersPenyewaanModel? users;
  final String? carName;
  final num? harga;
  final String? deskripsi;

  PenyewaanModel({
    required this.uid,
    required this.users,
    required this.carName,
    required this.harga,
    required this.deskripsi,
  });

  factory PenyewaanModel.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final uid = doc.id;
    final data = doc.data();
    return PenyewaanModel(
      uid: uid,
      users: UsersPenyewaanModel.fromFirestore(data['users']),
      carName: data['car_name'],
      harga: data['harga'],
      deskripsi: data['deskripsi'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'users': users?.toFirestore(),
      'car_name': carName,
      'harga': harga,
      'deskripsi': deskripsi,
    };
  }

  @override
  String toString() {
    return 'PenyewaanModel(uid: $uid, users: $users, carName: $carName, harga: $harga, deskripsi: $deskripsi)';
  }
}

class UsersPenyewaanModel {
  final String? uid;
  final String? rentalName;

  UsersPenyewaanModel({
    required this.uid,
    required this.rentalName,
  });

  factory UsersPenyewaanModel.fromFirestore(Map<String, dynamic> data) {
    return UsersPenyewaanModel(
      uid: data['uid'],
      rentalName: data['rental_name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'rental_name': rentalName,
    };
  }

  @override
  String toString() => 'UsersModel(uid: $uid, rentalName: $rentalName)';
}
