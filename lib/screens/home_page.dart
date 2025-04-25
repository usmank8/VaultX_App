import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vaultx_solution/screens/guest_registration.dart';
import 'package:vaultx_solution/screens/vehicle_registration.dart';
import 'otp_screen.dart'; // Import OtpScreen
import 'package:vaultx_solution/widgets/custom_app_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton("Generate OTP", Icons.add, context),
                _buildActionButton(
                    "Add a Guest", Icons.person_add_alt, context),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Guests Section
            _buildCard(
              context: context, // Pass context here
              title: "Guests",
              trailingText: "Edit",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGuestRow("David Cullen", "2:30 pm", Colors.brown),
                  _buildGuestRow("David Cullen", "4 pm", Colors.pink.shade200),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Vehicles Section
            _buildCard(
              context: context, // Pass context here
              title: "Vehicles",
              trailingText: "Add",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleRow("Honda civic", "BYS-456"),
                  _buildVehicleRow("Toyota Corolla", "BYS-456"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF600f0f),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'Add Guest'),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton.icon(
          onPressed: () {
            if (text == "Generate OTP") {
              // Navigate to OTP screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OtpScreen()),
              );
            } else if (text == "Add a Guest") {
              // Navigate to Register Guest screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GuestRegistrationForm()),
              );
            }
          },
          style: OutlinedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Colors.redAccent),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          icon: Icon(icon, size: 18, color: Colors.redAccent),
          label: Text(text, style: const TextStyle(color: Colors.redAccent)),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context, // Add context as a parameter
    required String title,
    required String trailingText,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehicleRegistrationPage(),
                    ),
                  );
                },
                child: Text(trailingText), // Use trailingText here
              ),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildGuestRow(String name, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          )),
          CircleAvatar(radius: 8, backgroundColor: color),
          const SizedBox(width: 10),
          const Icon(Icons.remove_circle_outline, color: Colors.black54)
        ],
      ),
    );
  }

  static Widget _buildVehicleRow(String model, String plate) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model, style: TextStyle(fontWeight: FontWeight.w500)),
          Text(plate, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
