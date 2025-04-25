import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _SecurityCodeGeneratorState();
}

class _SecurityCodeGeneratorState extends State<OtpScreen> {
  List<int> securityCode = [1, 2, 3, 4, 5, 6]; // Default values

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150), // Adjust top spacing
                // Heading
                const Text(
                  'Drive Delegated, Security Maintained!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D2828), // Maroon/burgundy color
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 60), // Adjust spacing after heading

                // Generate Button
                ElevatedButton(
                  onPressed: () {
                    // Generate new security code
                    setState(() {
                      // This is just a placeholder - in a real app you'd generate actual secure codes
                      securityCode = List.generate(
                          6, (_) => (DateTime.now().millisecond % 9) + 1);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5A3A3), // Pink/rose color
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Click to Generate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 60), // Adjust spacing after button

                // Number boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          securityCode[index].toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60), // Adjust spacing after number boxes

                // Share Button
                ElevatedButton(
                  onPressed: () {
                    // Share functionality
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
                    'Share',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Adjust bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
