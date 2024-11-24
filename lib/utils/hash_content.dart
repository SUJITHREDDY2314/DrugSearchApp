import 'package:crypto/crypto.dart'; // Import the crypto package
import 'dart:convert'; // Ensure this import is at the top

String hashPassword(password) {
  var bytes = utf8.encode(password); // Convert password to bytes
  var digest = sha256.convert(bytes); // Get SHA-256 hash
  return digest.toString();
}
