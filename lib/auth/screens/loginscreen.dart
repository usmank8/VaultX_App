import 'package:flutter/material.dart';
import 'package:vaultx_solution/auth/screens/registerscreen.dart';
import 'package:vaultx_solution/components/auth_footer.dart';
import 'package:vaultx_solution/components/auth_form.dart';
import 'package:vaultx_solution/components/auth_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          const AuthHeader(title: 'Welcome back!'),
          // Form and Footer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Form
                    AuthForm(
                      buttonText: 'LOG IN',
                      showForgotPassword: true,
                      onForgotPassword: () {
                        // Add forgot password logic here
                      },
                    ),
                    const SizedBox(height: 20),
                    // Footer
                    AuthFooter(
                      linkText: 'Don’t have an account? SIGN UP',
                      onLinkTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} //yobro