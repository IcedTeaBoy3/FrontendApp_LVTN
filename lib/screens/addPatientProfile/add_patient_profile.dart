import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddPatientProfile extends StatelessWidget {
  const AddPatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        title: Center(
          child: const Text(
            'Thêm hồ sơ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: const Center(
        child: Text('Add Patient Profile Screen'),
      ),
    );
  }
}
