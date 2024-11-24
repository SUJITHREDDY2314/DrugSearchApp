import 'package:flutter/material.dart';
import 'package:flutter_application_1/menu/drug_search/drug_search.dart';
import 'package:flutter_application_1/menu/medicine_reminder/medicine_input.dart';
import './menu/menu_page.dart';
import './menu/user_details.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve user details from the static storage
    var userDetails = UserDetailsStorage.getUserDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      drawer: const MenuPage(), // Persistent menu drawer
      body: Center(
        child: userDetails == null
            ? const CircularProgressIndicator() // Show loading indicator if details are null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Center the text
                children: [
                  Text(
                    'Welcome, ${userDetails['full_name'] ?? 'Guest'}!', // Greeting with user's name
                    style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'We\'re excited to have you!\n Try out our two amazing new features:',
                    style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center, // Center-align the text
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to DrugSearch page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DrugSearch()),
                      );
                    },
                    child: const Text('Try the Drug Search'),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Medicine Reminder feature
                      // (Assuming you have a MedicineReminderPage)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MedicineForm()),
                      );
                    },
                    child: const Text('Set a Medicine Reminder'),
                  ),
                ],
              ),
      ),
    );
  }
}
