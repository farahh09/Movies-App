class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String imagePath;
  final int watchListCount;
  final int historyCount;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.imagePath,
    required this.watchListCount,
    required this.historyCount,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone_number'] ?? '',
      imagePath: map['image_path'] ?? 'assets/images/gamer (1) (1).png',
      watchListCount: map['watch_list'] ?? 0,
      historyCount: map['watch_history'] ?? 0,
    );
  }
} 