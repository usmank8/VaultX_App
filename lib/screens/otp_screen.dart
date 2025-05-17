import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<int> securityCode = [0, 0, 0, 0, 0, 0]; // Initial empty code
  List<int>? previousCode; // Track previous code to avoid repetition
  final Random _random = Random.secure(); // Use secure random for better security
  bool _isCodeGenerated = false;
  
  // Generate a truly random 6-digit code
  List<int> _generateRandomCode() {
    List<int> newCode = List.generate(6, (_) => _random.nextInt(10));
    
    // Check if this code matches the previous one
    if (previousCode != null) {
      // If codes are identical, regenerate
      bool identical = true;
      for (int i = 0; i < 6; i++) {
        if (newCode[i] != previousCode![i]) {
          identical = false;
          break;
        }
      }
      
      // Regenerate if identical
      if (identical) {
        return _generateRandomCode(); // Recursively try again
      }
    }
    
    return newCode;
  }
  
  // Generate a new security code
  void _generateNewCode() {
    // Store current code as previous before generating new one
    if (_isCodeGenerated) {
      previousCode = List.from(securityCode);
    }
    
    setState(() {
      securityCode = _generateRandomCode();
      _isCodeGenerated = true;
    });
    
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New security code generated'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF7D2828),
      ),
    );
  }
  
  // Share the security code
  void _shareCode() {
    if (!_isCodeGenerated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please generate a code first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Format code for sharing
    String formattedCode = securityCode.join(' ');
    
    // Share the code
    Share.share(
      'Here is your security code for VaultX: $formattedCode',
      subject: 'VaultX Security Code',
    );
  }
  
  // Copy code to clipboard
  void _copyToClipboard() {
    if (!_isCodeGenerated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please generate a code first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    String formattedCode = securityCode.join('');
    Clipboard.setData(ClipboardData(text: formattedCode));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        backgroundColor: Color(0xFF7D2828),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7D2828)),
        title: const Text(
          'Security Code',
          style: TextStyle(color: Color(0xFF7D2828)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                
                // Heading
                const Text(
                  'Drive Delegated, Security Maintained!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D2828), // Maroon/burgundy color
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Subheading
                Text(
                  _isCodeGenerated 
                      ? 'Your unique security code is ready to share'
                      : 'Generate a unique security code to share',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 60),

                // Number boxes with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: _isCodeGenerated ? const Color(0xFFFFF8F8) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: _isCodeGenerated 
                        ? Border.all(color: const Color(0xFFD5A3A3), width: 1)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 45,
                        height: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: _isCodeGenerated 
                                ? const Color(0xFFD5A3A3) 
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: _isCodeGenerated ? [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            _isCodeGenerated ? securityCode[index].toString() : "-",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: _isCodeGenerated 
                                  ? const Color(0xFF7D2828)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Generate Button
                ElevatedButton(
                  onPressed: _generateNewCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD5A3A3), // Pink/rose color
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isCodeGenerated ? Icons.refresh : Icons.security,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isCodeGenerated ? 'Generate New Code' : 'Generate Security Code',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Action buttons
                if (_isCodeGenerated)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Copy Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _copyToClipboard,
                          icon: const Icon(Icons.copy, size: 18),
                          label: const Text('Copy'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7D2828),
                            elevation: 0,
                            side: const BorderSide(color: Color(0xFFD5A3A3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Share Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareCode,
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7D2828),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
