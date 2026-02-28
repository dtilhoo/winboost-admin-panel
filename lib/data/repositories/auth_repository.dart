class AuthRepository {
  Future<bool> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Accept any non-empty credentials for MVP demo purposes
    if (email.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    throw Exception('Invalid email or password');
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
