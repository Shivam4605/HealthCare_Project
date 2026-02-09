import 'package:shared_preferences/shared_preferences.dart';

class UserCredentials {
  String email = '';
  String password = '';
  String selectedRole = '';
  String uid = '';
  bool isLoggedIn = false;

  Future<void> setUserCredentials({
    required String email,
    required String password,
    required String selectedRole,
    required String uid,
    required bool isLoggedIn,
  }) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email);
    sharedPreferences.setString('password', password);
    sharedPreferences.setString('selectedRole', selectedRole);
    sharedPreferences.setString('uid', uid);
    sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  }

  Future<Map<String, dynamic>> fetchUserCredentials() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    email = sharedPreferences.getString('email') ?? '';
    password = sharedPreferences.getString('password') ?? '';
    selectedRole = sharedPreferences.getString('selectedRole') ?? '';
    uid = sharedPreferences.getString('uid') ?? '';
    isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    Map<String, dynamic> userData = {
      'email': email,
      'password': password,
      'selectedRole': selectedRole,
      'uid': uid,
      'isLoggedIn': isLoggedIn,
    };

    return userData;
  }

  Future<void> clearUserCredentials() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}
