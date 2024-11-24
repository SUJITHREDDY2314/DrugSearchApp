import 'package:flutter/material.dart';
import '../utils/mock_api.dart'; // Import the mock API
import '../utils/hash_content.dart';
import '../user_registration/register_page.dart';
import '../welcome_page.dart';
import '../menu/user_details.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Controllers to get input from text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // Login button handler
  void _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    setState(() {
      _isLoading = true;
    });

    bool _isValid =
        await MockAPI.validateLogin(username, hashPassword(password));
    
    if (_isValid) {
      final userDetails = await MockAPI.getUserDetails(username);
      if (userDetails != null) {
        UserDetailsStorage.saveUserDetails(
          userDetails['email']!,
          userDetails['full_name']!,
          userDetails['dob']!,
        );
      }
      setState(() {
      _isLoading = false; // Hide loading indicator
    });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              WelcomePage(),
        ),
      );
    } else {
      setState(() {
      _isLoading = false; // Hide loading indicator
    });
      // Failed login
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Invalid username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Image.asset(
                'assets/logo.png', // Path to the asset
                width: 150, // Adjust width and height as needed
                height: 150,
              ),
            ),
            const SizedBox(height: 22.0), // Spacing below the logo
            // Username TextField
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0), // Spacing

            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true, // Hides the text (for passwords)
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0), // Spacing

            // Login Button
            _isLoading
                ? const CircularProgressIndicator() // Show loading spinner
                : ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _handleLogin();
                      },
                    child: const Text('Login'),
                  ),
              TextButton(
              onPressed: () {
                // Navigate to the registration page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Create a new account"),
              ),
          ],
        ),
      ),
    );
  }
}
