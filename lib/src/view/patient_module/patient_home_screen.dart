import 'package:flutter/material.dart';
import 'package:healthcare/src/controller/auth_provider/logout_provider.dart';
import 'package:provider/provider.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PatientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              "Welcome to the Home Screen patient",
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
