import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/mock_api.dart'; // Import the mock API


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reenterPasswordController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();

  bool passwordsMatch = false;
  bool agreedToTerms = false;
  bool isEmailValid = false;
  bool isDateValid = false;

  String passwordStrength = "Weak";
  Color passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    dobController.addListener(() {
      if (dobController.text.length == 2 || dobController.text.length == 5) {
        dobController.text += "/";
        dobController.selection = TextSelection.fromPosition(
          TextPosition(offset: dobController.text.length),
        );
      }
    });
  }

  String evaluatePasswordStrength(String password) {
    int strengthScore = 0;
    int extra = 0;
    if (password.length >= 8) strengthScore++;
    if (password.length >= 12) extra++;
    if (password.contains(RegExp(r'[A-Z]'))) strengthScore++;
    if (password.contains(RegExp(r'[a-z]'))) strengthScore++;
    if (password.contains(RegExp(r'[0-9]'))) strengthScore++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strengthScore++;

    // Update password strength and color
    if (strengthScore < 5) {
      setState(() {
        passwordStrength = "Weak";
        passwordStrengthColor = Colors.red;
      });
    } else if (strengthScore + extra == 5) {
      setState(() {
        passwordStrength = "Moderate";
        passwordStrengthColor = Colors.orange;
      });
    } else {
      setState(() {
        passwordStrength = "Strong";
        passwordStrengthColor = Colors.green;
      });
    }

    return passwordStrength;
  }

  bool isValidDate(String date) {
    try {
      // Check if the date matches the format DD/MM/YYYY
      final parts = date.split('/');
      if (parts.length != 3) return false;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final currentYear = DateTime.now().year;
      // Check if month is valid
      if (month < 1 || month > 12) return false;
      if (currentYear - year > 150 || currentYear - year < 5) return false;
      // Check if day is valid for the given month
      final daysInMonth = [
        31,
        28 + (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 1 : 0),
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
      ];
      if (day < 1 || day > daysInMonth[month - 1]) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  bool checkForm() {
    return isEmailValid &&
        passwordStrength != "Weak" &&
        passwordsMatch &&
        agreedToTerms &&
        isDateValid;
  }

  String formatDate(String value) {
    String formatted = value.replaceAll(RegExp(r'[^0-9]'), '');
    print(formatted);
    if (formatted.length > 2 && !formatted.contains('/')) {
      formatted = formatted.substring(0, 2) + '/' + formatted.substring(2);
    }
    if (formatted.length > 5 && formatted.indexOf('/', 3) == -1) {
      formatted = formatted.substring(0, 5) + '/' + formatted.substring(5);
    }
    if (formatted.length > 10) {
      formatted = formatted.substring(0, 10); // Ensure valid length
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Full Name Field
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 10),

            // Email Field with Validation
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email (Username)',
                errorText: isEmailValid || emailController.text.isEmpty
                    ? null
                    : "Enter a valid email address",
              ),
              onChanged: (value) {
                setState(() {
                  isEmailValid =
                      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$")
                          .hasMatch(value);
                });
              },
            ),
            SizedBox(height: 10),

            // Password Field with Strength Indicator
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    passwordStrength,
                    style: TextStyle(color: passwordStrengthColor),
                  ),
                ),
              ),
              onChanged: (value) {
                evaluatePasswordStrength(value);
                setState(() {
                  passwordsMatch = value == reenterPasswordController.text;
                });
              },
            ),
            SizedBox(height: 10),

            // Re-enter Password Field with Match Indicator
            TextField(
              controller: reenterPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Re-enter Password',
                suffixIcon: Icon(
                  passwordsMatch ? Icons.check : Icons.close,
                  color: passwordsMatch ? Colors.green : Colors.red,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  passwordsMatch = (value == passwordController.text);
                });
              },
            ),
            SizedBox(height: 10),

            // Date of Birth Field with Date Picker
            TextField(
              controller: dobController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: 'Date of Birth (DD/MM/YYYY)',
                hintText: 'Enter date or use picker',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dobController.text =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        isDateValid = isValidDate(dobController.text);
                      });
                    }
                  },
                ),
                errorText: isDateValid || dobController.text.isEmpty
                    ? null
                    : "Please enter a valid date",
              ),
              onChanged: (value) {
                print(value);
                String formatted = formatDate(value);
                isDateValid = isValidDate(formatted);
                setState(() {
                  dobController.text = formatted;
                  dobController.selection = TextSelection.fromPosition(
                    TextPosition(offset: formatted.length),
                  );
                });
              },
            ),
            SizedBox(height: 10),

            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreedToTerms = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the Terms and Conditions',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: checkForm()
                  ? () {

                    MockAPI.registerUser(emailController.text, passwordController.text, fullNameController.text, dobController.text); 
                      // You can handle form submission here
                      print("Full Name: ${fullNameController.text}");
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");
                      print("Date of Birth: ${dobController.text}");
                      print("Agreed to Terms: $agreedToTerms");

                      Navigator.pop(context); // Navigate back to login
                    }
                  : null, // Disable button if validation fails
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
