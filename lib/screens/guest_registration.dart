import 'package:flutter/material.dart';
import 'package:vaultx_solution/screens/guest_registration_confirmed.dart';

class GuestRegistrationForm extends StatefulWidget {
  const GuestRegistrationForm({super.key});

  @override
  State<GuestRegistrationForm> createState() => _GuestRegistrationFormState();
}

class _GuestRegistrationFormState extends State<GuestRegistrationForm> {
  final TextEditingController nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController contactController =
      TextEditingController(text: 'John Doe');
  final TextEditingController dateTimeController =
      TextEditingController(text: 'John Doe');
  final TextEditingController genderController =
      TextEditingController(text: 'John Doe');

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    dateTimeController.dispose();
    genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header
              const Center(
                child: Text(
                  'Guest registration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 32),

              // Form fields
              _buildFormField('Name', nameController),
              const SizedBox(height: 20),
              _buildFormField('Contact Number', contactController),
              const SizedBox(height: 20),
              _buildFormField('Expected date and time', dateTimeController),
              const SizedBox(height: 20),
              _buildFormField('Gender', genderController),
              const SizedBox(height: 32),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GuestConfirmationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5A3A3), // Pink/rose color
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFEECEC), // Light pink background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFE57373), // Pink text color to match the design
          ),
        ),
      ],
    );
  }
}
