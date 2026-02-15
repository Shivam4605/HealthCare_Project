import 'package:flutter/material.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/logout_provider.dart';
import 'package:provider/provider.dart';

class MedicalStaffHomeScreen extends StatefulWidget {
  const MedicalStaffHomeScreen({super.key});

  @override
  State<MedicalStaffHomeScreen> createState() => _MedicalStaffHomeScreenState();
}

class _MedicalStaffHomeScreenState extends State<MedicalStaffHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Welcome to the Home Screen medical staff",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<LogoutProvider>(
                context,
                listen: false,
              ).logout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
