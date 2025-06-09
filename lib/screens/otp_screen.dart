import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _otpController = TextEditingController();
  bool _isSending = false;
  bool _isOTPSent = false;
  bool _isVerifying = false;
  bool _isResending = false;

  Future<void> _sendOtp() async {
    setState(() => _isSending = true);
    try {
      await _api.sendOtp(widget.email);
      setState(() => _isOTPSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('OTP sent to your email'),
            backgroundColor: Color(0xFF7D2828)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Enter a 6-digit code'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isVerifying = true);
    try {
      await _api.verifyOtp(widget.email, code);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('OTP verified successfully'),
            backgroundColor: Color(0xFF7D2828)),
      );
      // Redirect to login page after successful verification
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    try {
      await _api.resendOtp(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('OTP resent'), backgroundColor: Color(0xFF7D2828)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isResending = false);
    }
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
          'OTP Verification',
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
                const Text(
                  'Verify Your Email',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D2828),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isOTPSent
                      ? 'Enter the 6-digit OTP sent to your email'
                      : 'Send an OTP to your email to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                if (!_isOTPSent)
                  ElevatedButton(
                    onPressed: _isSending ? null : _sendOtp,
                    child: _isSending
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send OTP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD5A3A3),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                  )
                else ...[
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Enter 6-digit OTP',
                      border: OutlineInputBorder(),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOtp,
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify OTP'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7D2828),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                  ),
                  TextButton(
                    onPressed: _isResending ? null : _resendOtp,
                    child: _isResending
                        ? const CircularProgressIndicator()
                        : const Text('Resend OTP'),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
