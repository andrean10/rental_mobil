class KendaraanModel {
  final String? uid;
  final String? carName;
  final num? harga;
  final String? deskripsi;
  final String? urlImg;
  final UserKendaraan? user;

  KendaraanModel({
    this.uid,
    required this.carName,
    required this.harga,
    required this.deskripsi,
    this.urlImg,
    this.user,
  });

  factory KendaraanModel.fromFirestore(Map<String, dynamic> data) {
    return KendaraanModel(
      uid: data['uid'],
      carName: data['car_name'],
      harga: data['harga'],
      deskripsi: data['deskripsi'],
      urlImg: data['url_img'],
      user: UserKendaraan.fromFirestore(data['users']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'car_name': carName,
      'harga': harga,
      'deskripsi': deskripsi,
      'url_img': urlImg,
      'users': user?.toFirestore(),
    };
  }

  KendaraanModel copyWith({
    String? uid,
    String? carName,
    num? harga,
    String? deskripsi,
    String? urlImg,
    UserKendaraan? user,
  }) {
    return KendaraanModel(
      uid: uid ?? this.uid,
      carName: carName ?? this.carName,
      harga: harga ?? this.harga,
      deskripsi: deskripsi ?? this.deskripsi,
      urlImg: urlImg ?? this.urlImg,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'KendaraanModel{uid: $uid, carName: $carName, harga: $harga, deskripsi: $deskripsi, urlImg: $urlImg, user: $user';
  }
}

class UserKendaraan {
  final String? uid;

  UserKendaraan({this.uid});

  factory UserKendaraan.fromFirestore(Map<String, dynamic>? data) {
    return UserKendaraan(
      uid: data?['uid'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
    };
  }

  @override
  String toString() {
    return 'UserKendaraan{uid: $uid}';
  }
}
