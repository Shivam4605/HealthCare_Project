class UserModel {
  final String uid;
  final String fullName;
  final String userName;
  final String email;
  final String phone;
  final String userType;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullName": fullName,
      "userName": userName,
      "email": email,
      "phone": phone,
      "userType": userType,
      "createdAt": DateTime.now(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullName: map['fullName'],
      userName: map['userName'],
      email: map['email'],
      phone: map['phone'],
      userType: map['userType'],
    );
  }
}
