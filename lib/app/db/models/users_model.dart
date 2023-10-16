class UsersModel {
  final String? uid;
  final String? email;
  final String? fullName;
  final String? rentalName;
  final String? numberPhone;
  final String? address;
  final int? role;
  final String? urlImage;
  final DateTime? createdAt;

  UsersModel({
    this.uid,
    required this.email,
    required this.fullName,
    this.rentalName,
    required this.numberPhone,
    required this.address,
    required this.role,
    this.urlImage,
    this.createdAt,
  });

  UsersModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? rentalName,
    String? numberPhone,
    String? address,
    int? role,
    String? urlImage,
    DateTime? createdAt,
  }) {
    return UsersModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      rentalName: rentalName ?? this.rentalName,
      numberPhone: numberPhone ?? this.numberPhone,
      address: address ?? this.address,
      role: role ?? this.role,
      urlImage: urlImage ?? this.urlImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UsersModel.fromFirestore(Map<String, dynamic>? data) {
    return UsersModel(
      uid: data?['uid'],
      email: data?['email'],
      fullName: data?['full_name'],
      rentalName: data?['rental_name'],
      numberPhone: data?['phone_number'],
      address: data?['address'],
      role: data?['role'],
      urlImage: data?['url_img'],
      createdAt: data?['created_at']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'full_name': fullName,
      'rental_name': rentalName,
      'phone_number': numberPhone,
      'address': address,
      'role': role,
      'url_img': urlImage,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'UsersModel(uid: $uid, email: $email, fullName: $fullName, rentalName: $rentalName, numberPhone: $numberPhone, address: $address, role: $role, urlImage: $urlImage, createdAt: $createdAt)';
  }
}
