import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthcare/src/model/user_model/user_selectrole_model.dart';

class UserInfoProvider with ChangeNotifier {
  UserModel userModel = UserModel(selectedRole: '');
  void setSelectedRole(String role) {
    userModel.selectedRole = role;
    log('Selected Role: ${userModel.selectedRole}');
    notifyListeners();
  }
}
