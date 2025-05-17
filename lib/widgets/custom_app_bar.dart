import 'package:flutter/material.dart';
import 'package:vaultx_solution/auth/screens/loginscreen.dart';
import 'package:vaultx_solution/screens/change_password_page.dart';
import 'package:vaultx_solution/services/api_service.dart';
import 'package:vaultx_solution/models/create_profile_model.dart';
import 'profile_dropdown.dart';

class CustomAppBar extends StatelessWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final CreateProfileModel? userProfile;
  
  const CustomAppBar({
    Key? key, 
    this.showBackButton = false,
    this.actions,
    this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      titleSpacing: 16,
      leading: showBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ) : null,
      title: Row(
        children: [
          Image.asset(
            'assets/vx_logo.png', 
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Color(0xFFD6A19F),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'V',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Navigate to notifications page
              // Navigator.pushNamed(context, '/notifications');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications coming soon')),
              );
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: Color(0xFF600f0f),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showProfileDropdown(context);
            },
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFD6A19F),
                  radius: 18,
                  child: Text(
                    userProfile != null 
                        ? userProfile!.firstname[0].toUpperCase() 
                        : 'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      actions: actions,
    );
  }

  void _showProfileDropdown(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width - 250, button.size.height + 10), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.transparent,
      items: [
        PopupMenuItem<String>(
          padding: EdgeInsets.zero,
          child: ProfileDropdown(
            userName: userProfile != null 
                ? "${userProfile!.firstname} ${userProfile!.lastname}" 
                : "User",
            userImage: "assets/profile.png",
            onClose: () => Navigator.pop(context),
            onLogout: () async {
              Navigator.pop(context);
              await _handleLogout(context);
            },
            onEditProfile: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/edit-profile');
            },
            onChangePassword: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD6A19F),
        ),
      ),
    );

    try {
      final apiService = ApiService();
      await apiService.logout();
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Navigate to login page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: ${e.toString()}')),
      );
    }
  }
}
