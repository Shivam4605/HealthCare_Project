import 'package:flutter/material.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/logout_provider.dart';
import 'package:provider/provider.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Welcome to the Home Screen doctor",
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
