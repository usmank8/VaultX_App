import 'package:flutter/material.dart';
import 'package:vaultx_solution/auth/screens/loginscreen.dart';
import 'package:vaultx_solution/components/auth_footer.dart';
import 'package:vaultx_solution/components/auth_form.dart';
import 'package:vaultx_solution/components/auth_header.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          const AuthHeader(title: 'Sign Up'),
          // Form and Footer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Form
                    const AuthForm(
                      buttonText: 'SIGN UP',
                      showForgotPassword: false,
                    ),
                    const SizedBox(height: 20),
                    // Footer
                    AuthFooter(
                      linkText: 'ALREADY SIGN UP? LOGIN',
                      onLinkTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
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
}