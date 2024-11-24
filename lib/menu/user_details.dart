class UserDetailsStorage {
  // Use a static map to store user details globally in the app
  static Map<String, String> _userDetails = {};

  // Save user details to the map
  static void saveUserDetails(String email, String fullName, String dob) {
    _userDetails = {
      'email': email,
      'full_name': fullName,
      'dob': dob,
    };
  }

  // Retrieve user details from the map
  static Map<String, String>? getUserDetails() {
    return _userDetails.isNotEmpty ? _userDetails : null;
  }

  // Clear user details
  static void clearUserDetails() {
    _userDetails = {};
  }
}
