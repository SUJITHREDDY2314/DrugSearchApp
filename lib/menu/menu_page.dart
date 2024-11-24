import 'package:flutter/material.dart';
import 'package:flutter_application_1/menu/drug_search/drug_search.dart';
import 'package:flutter_application_1/menu/medicine_reminder/medicine_input.dart';
import 'profile_page.dart';
import 'help_page.dart';
import 'logout.dart';
import '../welcome_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.search), // Icon for drug search
            title: const Text('Drug Search'), // Text for drug search
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  DrugSearch()), // Navigate to the drug search page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Medicine Reminder'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedicineForm()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Need Help?'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              LogoutDialog.showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
