import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';


class GuestConfirmationPage extends StatefulWidget {
  const GuestConfirmationPage({Key? key}) : super(key: key);

  @override
  State<GuestConfirmationPage> createState() => _GuestConfirmationPageState();
}

class _GuestConfirmationPageState extends State<GuestConfirmationPage> {
  bool _showQR = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Heading
                const Text(
                  'Guest Added!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D2828), // Maroon/burgundy color
                  ),
                ),
                const SizedBox(height: 40),
                
                // Checkmark image
                Image.asset(
                  'assets/qr_confirm.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 40),
                
                // Generate QR Code Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showQR = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5A3A3), // Pink/rose color
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(200, 45),
                  ),
                  child: const Text(
                    'Generate QR Code',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // QR Code
                if (_showQR) ...[
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/qr.png',
                      width: 130,
                      height: 130,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Share Button
                  ElevatedButton(
                    onPressed: () {
                      // Share functionality
                      Share.share('Guest registration confirmed! Here is your QR code.');
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}