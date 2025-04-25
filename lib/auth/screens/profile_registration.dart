import 'package:flutter/material.dart';
import 'package:vaultx_solution/loading/loading.dart';
import 'package:vaultx_solution/screens/home_page.dart'; // UnderReviewScreen import

class ProfileRegistrationPage extends StatelessWidget {
  const ProfileRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          'Profile registration',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Profile completion: 60%"),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.6,
                minHeight: 10,
                backgroundColor: const Color(0xFFF8DADA),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF5C0D0D)), // dark brown
              ),
            ),
            const SizedBox(height: 24),
            _buildInputRow("First Name", "Last Name"),
            _buildInput("Phone Number"),
            _buildInput("CNIC Number"),
            _buildInput("Block"),
            _buildInput("Street number"),
            _buildDropdown("Residence (dropdown)", ["House", "Apartment"]),
            _buildInput("Residence Number"),
            _buildDropdown("Residence Type (Owned or Rented Dropdown)",
                ["Owned", "Rented"]),
            _buildInput(
                "Floor Number (apartment or house floor number if house is rented)",
                hint: "House or building number"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Show UnderReviewScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnderReviewScreen(),
                    ),
                  );

                  // After 2 seconds, navigate to DashboardPage
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6A19F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint ?? "John Doe",
            filled: true,
            fillColor: const Color(0xFFFFF1ED),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ]),
    );
  }

  Widget _buildDropdown(String label, List<String> options) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF1ED),
            borderRadius: BorderRadius.circular(24),
          ),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            hint: const Text("House or Apartment"),
            items: options
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
            onChanged: (value) {},
          ),
        ),
      ]),
    );
  }

  Widget _buildInputRow(String label1, String label2) {
    return Row(
      children: [
        Expanded(child: _buildInput(label1)),
        const SizedBox(width: 16),
        Expanded(child: _buildInput(label2)),
      ],
    );
  }
}
