import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'menu_page.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  // Function to initiate a phone call
  Future<void> callNumber(String number) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: number,
    );
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not place the call.';
    }
  }

  @override
  Widget build(BuildContext context) {
    const phoneNumber = '+1-(817)-524-8487';
    const emailAddress = 'support@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Need Help?'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const MenuPage(), // Persistent menu drawer
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Phone Number Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.blueAccent),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => callNumber(phoneNumber),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Phone Number:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              phoneNumber,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // Email Section
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email ID:',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            emailAddress,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30.0),

            // Placeholder Footer
            Center(
              child: Text(
                'We are here to assist you 24/7.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
