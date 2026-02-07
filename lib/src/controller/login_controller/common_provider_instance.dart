import 'package:flutter/foundation.dart';
import 'package:healthcare/src/controller/login_controller/login_provider.dart';

class CommonProviderInstance with ChangeNotifier {
  LoginProvider loginProvider = LoginProvider();
}
