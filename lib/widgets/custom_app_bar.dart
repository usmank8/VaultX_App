import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vaultx_solution/widgets/profile_dropdown.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      backgroundColor: Colors.white,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset('assets/vx_logo.png', height: 40), // Your logo
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/notification.svg',
              height: 24,
              width: 24,
            ),
          ),
          GestureDetector(
            onTap: () {
              _showProfileDropdown(context);
            },
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/profile.png'),
                  radius: 18,
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
          )
        ],
      ),
    );
  }

  void _showProfileDropdown(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
            Offset(button.size.width - 250, button.size.height + 10),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
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
            userName: "Usman Khalil",
            userImage: "assets/profile.png",
            onClose: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
