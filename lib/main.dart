// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaultx_solution/auth/screens/loginscreen.dart';
import 'package:vaultx_solution/auth/screens/registerscreen.dart';
import 'package:vaultx_solution/screens/guest_registration_confirmed.dart';
import 'package:vaultx_solution/screens/home_page.dart';
import 'package:vaultx_solution/screens/otp_screen.dart';
import 'package:vaultx_solution/screens/vehicle_registration.dart';
import 'app_theme.dart';

import 'widgets/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visitor Management',
      theme: AppTheme.theme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const AuthPage(),
        '/home': (context) => const MainLayout(initialIndex: 0),
        '/notifications': (context) => const MainLayout(initialIndex: 1),
        '/guest-registration': (context) => const MainLayout(initialIndex: 2),
      },
      onGenerateRoute: (settings) {
        // Handle other routes that need the bottom navigation bar
        if (!settings.name!.contains('/login') && 
            !settings.name!.contains('/register')) {
          return MaterialPageRoute(
            builder: (context) {
              // Determine which screen to show based on the route
              Widget child;
              int navIndex = 0;
              
              if (settings.name == '/guest-registration-confirmed') {
                // Import and use the appropriate screen
              
                child = const GuestConfirmationPage();
              } else if (settings.name == '/vehicle-registration') {
             
                child = const VehicleRegistrationPage();
              } else if (settings.name == '/otp-screen') {
                
                child = const OtpScreen();
              } else {
                // Default to home page
               
                child = const DashboardPage();
              }
              
              return MainLayout(initialIndex: navIndex, child: child);
            },
          );
        }
        
        // For login and register screens, don't use the MainLayout
        return null;
      },
    );
  }
}