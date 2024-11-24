import 'package:flutter/material.dart';
import 'menu_page.dart';
import 'user_details.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var userDetails = UserDetailsStorage.getUserDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const MenuPage(), // Persistent menu drawer
      body: userDetails == null
          ? const Center(child: CircularProgressIndicator()) // Show loading if userDetails is null
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(
                        Icons.person,
                        size: 60.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // Full Name
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blueAccent),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Full Name: ${userDetails['full_name'] ?? 'Not available'}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Email (Display Only, No Interaction)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.email, color: Colors.blueAccent),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Email: ${userDetails['email'] ?? 'Not available'}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Date of Birth
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blueAccent),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Date of Birth: ${userDetails['dob'] ?? 'Not available'}',
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
