// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaultx_solution/models/update_profile_model.dart';

import 'authenticated_client.dart';
import '../models/sign_up_model.dart';
import '../models/sign_in_model.dart';
import '../models/create_profile_model.dart';
import '../models/update_password_model.dart';
import '../models/vehicle_model.dart';
import '../models/guest_model.dart';

class ApiService {
  // 1) our custom HTTP client that injects Authorization header
  final AuthenticatedClient _client = AuthenticatedClient();

  // 2) Base URL switches for Android vs iOS/web
  String get _baseUrl {
    if (Platform.isAndroid) {
      return 'https://vaultx-be-sq00.onrender.com';
    } else {
      return 'https://vaultx-be-sq00.onrender.com';
    }
  }

  // Add in-memory token storage
  String? _inMemoryToken;

  // Set token in memory
  void setInMemoryToken(String token) {
    _inMemoryToken = token;
    _client.setToken(token);
  }

  // Add this method to debug the token
  void debugToken() {
    _client.debugToken();
  }

  /// ─── SIGN UP (public) ───────────────────────────────────────────
  Future<void> signUp(SignUpModel dto) async {
    final uri = Uri.parse('$_baseUrl/auth/signup');

    try {
      debugPrint('Sending signup request to: $uri');
      debugPrint('Request body: ${jsonEncode(dto.toJson())}');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      debugPrint('Signup response status: ${res.statusCode}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        debugPrint('Signup successful');
        return;
      } else {
        // Try to parse error message from response
        String errorMessage;
        try {
          final errorBody = jsonDecode(res.body);
          errorMessage =
              errorBody['message'] ?? 'Signup failed (${res.statusCode})';
        } catch (_) {
          errorMessage = 'Signup failed (${res.statusCode}): ${res.body}';
        }

        debugPrint('Signup error: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// ─── LOGIN (public) ─────────────────────────────────────────────
  /// on success stores the JWT in SharedPreferences and returns the token
  Future<String?> login(SignInModel dto) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dto.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final token = body['token'] as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_email', dto.email); // store user email

      if (body.containsKey('isApprovedBySocietyAdmin')) {
        await prefs.setBool(
          'isApprovedBySocietyAdmin',
          body['isApprovedBySocietyAdmin'] == true,
        );
      }
      return token;
    } else {
      throw Exception('Login failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── LOGOUT ─────────────────────────────────────────────────────
  /// Removes the stored JWT
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
    } catch (e) {
      debugPrint('Failed to remove token from SharedPreferences: $e');
    }

    // Always clear the in-memory token
    _inMemoryToken = null;
    _client.clearToken(); // Use a new method to clear the token
  }

  /// ─── PROFILE: GET /profile/me ───────────────────────────────────
  /// Returns your saved profile (or throws if something goes wrong)
  Future<CreateProfileModel?> getProfile() async {
    final uri = Uri.parse('$_baseUrl/profile/me');
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      return CreateProfileModel.fromJson(jsonDecode(res.body));
    } else if (res.statusCode == 404) {
      // no profile yet
      return null;
    } else {
      throw Exception('Fetch profile failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── PROFILE: POST /profile/create ──────────────────────────────
  Future<void> createProfile(CreateProfileModel dto) async {
    final uri = Uri.parse('$_baseUrl/profile/create');

    // Debug the token before making the request
    debugPrint('About to create profile, checking token:');
    _client.debugToken();

    // Debug the request body
    final requestBody = jsonEncode(dto.toJson());
    debugPrint('Profile create request body: $requestBody');

    try {
      // Ensure content type is set explicitly
      final res = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      debugPrint('Profile create response status: ${res.statusCode}');
      debugPrint('Profile create response body: ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        String errorMessage;
        try {
          final errorBody = jsonDecode(res.body);
          errorMessage = errorBody['message'] ??
              'Create profile failed (${res.statusCode})';
        } catch (_) {
          errorMessage =
              'Create profile failed (${res.statusCode}): ${res.body}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Profile create error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  //// ─── PROFILE: PUT /profile/update ──────────────────────────────
  Future<void> updateProfile(UpdateProfileModel dto) async {
    final uri = Uri.parse('$_baseUrl/profile/update');

    // Debug the token before making the request
    debugPrint('About to update profile, checking token:');
    _client.debugToken();

    // Debug the request body
    final requestBody = jsonEncode(dto.toJson());
    debugPrint('Profile update request body: $requestBody');

    try {
      // Ensure content type is set explicitly
      final res = await _client.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      debugPrint('Profile update response status: ${res.statusCode}');
      debugPrint('Profile update response body: ${res.body}');

      if (res.statusCode != 200 && res.statusCode != 201) {
        String errorMessage;
        try {
          final errorBody = jsonDecode(res.body);
          errorMessage = errorBody['message'] ??
              'Update profile failed (${res.statusCode})';
        } catch (_) {
          errorMessage =
              'Update profile failed (${res.statusCode}): ${res.body}';
        }

        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// ─── PROFILE: POST /profile/password/update ─────────────────────
  Future<void> updatePassword(UpdatePasswordModel dto) async {
    final uri = Uri.parse('$_baseUrl/profile/password/update');
    final res = await _client.post(
      uri,
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(
          'Password update failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── VEHICLE: POST /vehicle/add ─────────────────────────────────
  Future<void> addVehicle(VehicleModel dto) async {
    final uri = Uri.parse('$_baseUrl/vehicle/add');

    debugPrint('Adding vehicle: ${jsonEncode(dto.toJson())}');

    final res = await _client.post(
      uri,
      body: jsonEncode(dto.toJson()),
    );

    debugPrint('Add vehicle response: ${res.statusCode}');
    if (res.statusCode != 200 && res.statusCode != 201) {
      debugPrint('Add vehicle error body: ${res.body}');
      throw Exception('Add vehicle failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── VEHICLE: GET /vehicle ─────────────────────────────────────
  Future<List<VehicleModel>> getVehicles() async {
    final uri = Uri.parse('$_baseUrl/vehicle');
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      final List<dynamic> vehiclesJson = jsonDecode(res.body);
      return vehiclesJson.map((json) => VehicleModel.fromJson(json)).toList();
    } else {
      throw Exception('Fetch vehicles failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── GUEST: POST /guest/register ─────────────────────────────────
  Future<String> registerGuest(AddGuestModel dto) async {
    final uri = Uri.parse('$_baseUrl/guest/register');

    debugPrint('Registering guest: ${jsonEncode(dto.toJson())}');

    final res = await _client.post(
      uri,
      body: jsonEncode(dto.toJson()),
    );

    debugPrint('Register guest response: ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(res.body);
      return responseData['qrCodeImage'] ?? '';
    } else {
      debugPrint('Register guest error body: ${res.body}');
      throw Exception('Register guest failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── GUEST: GET /guest ─────────────────────────────────────────
  Future<List<GuestModel>> getGuests() async {
    final uri = Uri.parse('$_baseUrl/guest/guest/mine');
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      final List<dynamic> guestsJson = jsonDecode(res.body);
      return guestsJson.map((json) => GuestModel.fromJson(json)).toList();
    } else {
      throw Exception('Fetch guests failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── GUEST: POST /guest/verify ─────────────────────────────────
  Future<Map<String, dynamic>> verifyGuest(String guestId) async {
    final uri = Uri.parse('$_baseUrl/guest/verify');

    final res = await _client.post(
      uri,
      body: jsonEncode({'guestId': guestId}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Verify guest failed (${res.statusCode}): ${res.body}');
    }
  }

  /// ─── AUTH: POST /auth/otp/send ────────────────────────────────
  Future<void> sendOtp(String email) async {
    final uri = Uri.parse('$_baseUrl/auth/otp/send');
    final body = jsonEncode({'email': email});
    debugPrint('Sending OTP request to: $uri');
    debugPrint('Request body: $body');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    debugPrint('Send OTP response status: ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      debugPrint('OTP sent successfully');
      return;
    } else {
      String errorMessage;
      try {
        final errorBody = jsonDecode(res.body);
        errorMessage =
            errorBody['message'] ?? 'Send OTP failed (${res.statusCode})';
      } catch (_) {
        errorMessage = 'Send OTP failed (${res.statusCode}): ${res.body}';
      }
      throw Exception(errorMessage);
    }
  }

  /// ─── AUTH: POST /auth/otp/verify ───────────────────────────────
  Future<void> verifyOtp(String email, String otp) async {
    final uri = Uri.parse('$_baseUrl/auth/otp/verify');
    final body = jsonEncode({'email': email, 'otp': otp});
    debugPrint('Verifying OTP at: $uri');
    debugPrint('Request body: $body');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    debugPrint('Verify OTP response status: ${res.statusCode}');
    if (res.statusCode == 200 || res.statusCode == 201) {
      debugPrint('OTP verified successfully');
      return;
    } else {
      String errorMessage;
      try {
        final errorBody = jsonDecode(res.body);
        errorMessage =
            errorBody['message'] ?? 'Verify OTP failed (${res.statusCode})';
      } catch (_) {
        errorMessage = 'Verify OTP failed (${res.statusCode}): ${res.body}';
      }
      throw Exception(errorMessage);
    }
  }

  /// ─── AUTH: POST /auth/resend-otp ───────────────────────────────
  Future<void> resendOtp(String email) async {
    final uri = Uri.parse('$_baseUrl/auth/resend-otp');
    final body = jsonEncode({'email': email});
    debugPrint('Resending OTP request to: $uri');
    debugPrint('Request body: $body');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    debugPrint('Resend OTP response status: ${res.statusCode}');
    if (res.statusCode == 200) {
      return;
    } else {
      String errorMessage;
      try {
        final errorBody = jsonDecode(res.body);
        errorMessage =
            errorBody['message'] ?? 'Resend OTP failed (${res.statusCode})';
      } catch (_) {
        errorMessage = 'Resend OTP failed (${res.statusCode}): ${res.body}';
      }
      throw Exception(errorMessage);
    }
  }

  /// Retrieve the stored user email from SharedPreferences
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      debugPrint(
          'User email from SharedPreferences: ${email != null ? 'Found' : 'Not found'}');
      return email;
    } catch (e) {
      debugPrint('Error accessing user_email: $e');
      return null;
    }
  }
}
