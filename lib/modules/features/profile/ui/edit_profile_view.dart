import 'package:flutter/material.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _profileImage(),
            const SizedBox(height: 20),
            _profileForm(),
            const SizedBox(height: 20),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _profileForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Address',
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Save'),
    );
  }
}
