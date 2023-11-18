import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PesananModel {
  final String? uid;
  final UserOrder? userOrder;
  final KendaraanModel? kendaraanModel;
  final DateTime? tanggalMulai;
  final DateTime? tanggalSelesai;
  final num? harga;

  PesananModel({
    this.uid,
    required this.userOrder,
    required this.kendaraanModel,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.harga,
  });

  factory PesananModel.fromFirestore(Map<String, dynamic> data) {
    return PesananModel(
      uid: data['uid'],
      userOrder: UserOrder.fromFirestore(data['users']),
      kendaraanModel: KendaraanModel.fromFirestore(data['kendaraan']),
      tanggalMulai: data['tanggal_mulai'].toDate(),
      tanggalSelesai: data['tanggal_selesai'].toDate(),
      harga: data['harga'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'users': userOrder!.toFirestore(),
      'kendaraan': kendaraanModel!.toFirestore(),
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'harga': harga,
    };
  }

  @override
  String toString() {
    return 'PesananModel{uid: $uid, users: $userOrder, kendaraanModel: $kendaraanModel, tanggalMulai: $tanggalMulai, tanggalSelesai: $tanggalSelesai, harga: $harga}';
  }
}

class UserOrder {
  final User? order;
  final User? rental;

  UserOrder({
    required this.order,
    required this.rental,
  });

  UserOrder copyWith({
    User? order,
    User? rental,
  }) {
    return UserOrder(
      order: order ?? this.order,
      rental: rental ?? this.rental,
    );
  }

  factory UserOrder.fromFirestore(Map<String, dynamic> data) {
    return UserOrder(
      order: User.fromFirestore(data['order']),
      rental: User.fromFirestore(data['rental']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'order': order!.toFirestore(isRental: false),
      'rental': rental!.toFirestore(isRental: true),
    };
  }

  Map<String, dynamic> keluhanToFirestore() {
    return {
      'users': {
        'order': order!.toFirestore(isRental: false),
        'rental': rental!.toFirestore(isRental: true),
      }
    };
  }

  @override
  String toString() {
    return 'UserOrder{order: $order, rental: $rental}';
  }
}

class User {
  final String? uid;
  final String? fullName;
  final GeoPoint? location;
  final GeoPoint? locationKeluhan;
  final String? keluhan;

  User({
    required this.uid,
    required this.fullName,
    this.location,
    this.locationKeluhan,
    this.keluhan,
  });

  User copyWith({
    String? uid,
    String? fullName,
    GeoPoint? location,
    GeoPoint? locationKeluhan,
    String? keluhan,
  }) {
    return User(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
      locationKeluhan: locationKeluhan ?? this.locationKeluhan,
      keluhan: keluhan ?? this.keluhan,
    );
  }

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      fullName: data['full_name'],
      location: data['location'],
      locationKeluhan:
          (data['location_keluhan'] != null) ? data['location_keluhan'] : null,
      keluhan: (data['keluhan'] != null) ? data['keluhan'] : null,
    );
  }

  Map<String, dynamic> toFirestore({required bool isRental}) {
    if (isRental) {
      return {
        'uid': uid,
        'full_name': fullName,
        'location': location,
      };
    } else {
      return {
        'uid': uid,
        'full_name': fullName,
        'location': location,
        'location_keluhan': locationKeluhan,
        'keluhan': keluhan,
      };
    }
  }

  Map<String, dynamic> kelurahantoFirestore({required bool isRental}) {
    if (isRental) {
      return {
        'uid': uid,
        'full_name': fullName,
        'location': location,
      };
    } else {
      return {
        'uid': uid,
        'full_name': fullName,
        'location': location,
        'location_keluhan': locationKeluhan,
        'keluhan': keluhan,
      };
    }
  }



  @override
  String toString() {
    return 'User{uid: $uid, fullName: $fullName, location: lat = ${location?.latitude}, long = ${location?.longitude}, locationKeluhan: lat = ${locationKeluhan?.latitude}, long = ${locationKeluhan?.longitude}, keluhan: $keluhan}';
  }
}
