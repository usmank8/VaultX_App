import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaultx_solution/auth/screens/loginscreen.dart';
import 'package:vaultx_solution/auth/screens/profile_registration.dart';
import 'package:vaultx_solution/screens/home_page.dart';
import 'package:vaultx_solution/services/api_service.dart';
import 'package:flutter/foundation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation for logo
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.forward();
    
    // Check auth status after a short delay
    Future.delayed(Duration(seconds: 2), () {
      _checkAuthStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    final _api = ApiService();
    
    try {
      // Check if token exists in SharedPreferences
      SharedPreferences prefs;
      try {
        prefs = await SharedPreferences.getInstance();
      } catch (e) {
        debugPrint('Error initializing SharedPreferences: $e');
        _navigateToLogin();
        return;
      }
      
      final token = prefs.getString('jwt_token');
      
      if (token == null) {
        // No token, go to login
        _navigateToLogin();
        return;
      }
      
      // Set token in memory for immediate use
      _api.setInMemoryToken(token);
      
      // Verify token by trying to get profile
      try {
        final profile = await _api.getProfile();
        
        if (profile == null) {
          // Token is valid but no profile exists
          _navigateToProfileRegistration();
        } else {
          // Token is valid and profile exists
          _navigateToDashboard();
        }
      } catch (e) {
        debugPrint('Error verifying token: $e');
        
        // Token might be invalid or expired
        try {
          // Clear invalid token
          await prefs.remove('jwt_token');
        } catch (_) {}
        
        _navigateToLogin();
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _navigateToProfileRegistration() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileRegistrationPage()),
    );
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo with fade-in animation
            FadeTransition(
              opacity: _animation,
              child: ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  'assets/logo.png', // Make sure this asset exists
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if logo asset is missing
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFD6A19F),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'VaultX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            // App name with fade-in animation
            FadeTransition(
              opacity: _animation,
              child: Text(
                'VaultX Solution',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C0D0D),
                ),
              ),
            ),
            SizedBox(height: 50),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD6A19F)),
            ),
          ],
        ),
      ),
    );
  }
}
