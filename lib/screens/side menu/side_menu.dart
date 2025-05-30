import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../login/provider/ProfileProvider.dart';
import '../../models/auth.dart';
import '../../rotas/apiservice.dart';

class SideMenu extends StatefulWidget {
  final Function(String) onMenuItemSelected;
  final String userName;
  final String userEmail;
  final UserModel user;
  final VoidCallback onProfileImageUpdated;

  const SideMenu({
    required this.user,
    required this.onMenuItemSelected,
    required this.userName,
    required this.userEmail,
    required this.onProfileImageUpdated,
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late ApiService _apiService;
  String _selectedMenuItem = 'DashboardMaster';
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(baseUrl: 'https://api.painel.weellu.com');
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final base64Image = await _apiService.getProfileImage(widget.user.id);
      if (base64Image != null) {
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileImage(base64Image);
        widget.onProfileImageUpdated();
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  void _handleMenuItemSelected(String item) {
    setState(() {
      _selectedMenuItem = item;
    });
    widget.onMenuItemSelected(item);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = (screenWidth / 1920).clamp(0.5, 1.0);

    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Expanded(
          child: Container(
            color: const Color.fromARGB(255, 1, 4, 2),
            child: Column(
              children: [
                // Header with logo
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 30),
                    child: Row(
                      children: [
                        Container(
                          height: 60 * scaleFactor,
                          width: 60 * scaleFactor,
                          child: Image.asset('assets/weellu.png'),
                        ),
                        Text(
                          'Weellu',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 35 * scaleFactor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // User profile section (commented in original)
                Padding(
                  padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                ),

                // Menu Items
                _buildMenuItem(
                  index: 0,
                  icon: Icons.view_quilt_rounded,
                  label: 'Dashboard',
                  selectedValue: 'DashboardMaster',
                  onTap: () => _handleMenuItemSelected('DashboardMaster'),
                ),
                _buildMenuItem(
                  index: 1,
                  icon: Icons.supervisor_account_rounded,
                  label: 'Integration',
                  selectedValue: 'Integration',
                  onTap: () => _handleMenuItemSelected('Integration'),
                ),
                _buildMenuItem(
                  index: 2,
                  icon: Icons.sms,
                  label: 'Comentários',
                  selectedValue: 'Dashboard',
                  onTap: () => _handleMenuItemSelected('Dashboard'),
                ),
                _buildMenuItem(
                  index: 3,
                  icon: FontAwesomeIcons.bullhorn,
                  label: 'Broadcast',
                  selectedValue: 'ProfileUser',
                  onTap: () => _handleMenuItemSelected('ProfileUser'),
                ),
                _buildMenuItem(
                  index: 4,
                  icon: Icons.person,
                  label: 'Business',
                  selectedValue: 'business',
                  onTap: () => _handleMenuItemSelected('business'),
                ),
                _buildMenuItem(
                  index: 5,
                  icon: PhosphorIcons.flag_banner,
                  label: 'Adversiting',
                  selectedValue: 'Adversiting',
                  onTap: () => _handleMenuItemSelected('Adversiting'),
                ),
                _buildMenuItem(
                  index: 6,
                  icon: Icons.person,
                  label: 'Users',
                  selectedValue: 'users',
                  onTap: () => _handleMenuItemSelected('users'),
                ),
                _buildMenuItem(
                  index: 7,
                  icon: FontAwesomeIcons.phone,
                  label: 'Calls',
                  selectedValue: 'Calls',
                  onTap: () => _handleMenuItemSelected('Calls'),
                ),
                _buildMenuItem(
                  index: 8,
                  icon: FontAwesomeIcons.arrowTrendUp,
                  label: 'Surveys',
                  selectedValue: 'Surveys',
                  onTap: () => _handleMenuItemSelected('Surveys'),
                ),
                _buildMenuItem(
                  index: 9,
                  icon: Icons.account_box_outlined,
                  label: 'Logins',
                  selectedValue: 'tatateste',
                  onTap: () => _handleMenuItemSelected('tatateste'),
                ),
                _buildMenuItem(
                  index: 10,
                  icon: Icons.logout,
                  label: 'Logout',
                  selectedValue: 'Logout',
                  isLogout: true,
                  onTap: () => _handleMenuItemSelected('Logout'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
    required String selectedValue,
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedMenuItem == selectedValue;
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isSelected
              ? const Color(0xff051309)
              : isHovered
                  ? const Color.fromARGB(24, 255, 255, 255)
                  : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(left: 40.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: isLogout
                      ? Colors.red[400]
                      : (isSelected || isHovered)
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  size: 23.sp,
                ),
                Padding(
                  padding: EdgeInsets.all(7.sp),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: isLogout
                          ? Colors.red[400]
                          : (isSelected || isHovered)
                              ? Colors.white
                              : Colors.white.withOpacity(0.7),
                      fontSize: 20.sp,
                      fontWeight: isSelected ? FontWeight.w400 : FontWeight.w200,
                      height: 0,
                      letterSpacing: 1.50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}