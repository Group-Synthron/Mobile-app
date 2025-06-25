class AuthService {
  // Simulates a network call to your authentication backend (like Firebase)
  Future<bool> login(String email, String password) async {
    // Simulate a delay to represent a network request
    await Future.delayed(const Duration(seconds: 2));

    // This is where you would put your actual Firebase Auth logic.
    // For now, we use the sample credentials.
    if (email == 'admin@example.com' && password == 'password123') {
      // Login successful
      return true;
    } else {
      // Login failed
      return false;
    }
  }
}