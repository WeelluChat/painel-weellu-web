import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../login/provider/ProfileProvider.dart'; // Certifique-se de que o caminho está correto
import '../../models/auth.dart';
import '../../rotas/apiservice.dart';

class SideMenu extends StatefulWidget {
  final Function(String) onMenuItemSelected; // Callback para seleção do item
  final String userName;
  final String userEmail;
  final UserModel user;
  final VoidCallback onProfileImageUpdated; // Callback para atualizar a imagem

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
  String _selectedMenuItem =
      'DashboardMaster'; // Inicialmente seleciona o Dashboard

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(
      baseUrl: 'https://api.painel.weellu.com', // Configure seu URL base aqui
    );
    // Carregar a imagem de perfil assim que o widget for criado
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    try {
      final base64Image = await _apiService.getProfileImage(widget.user.id);
      if (base64Image != null) {
        // Atualiza o ProfileProvider com a imagem carregada
        Provider.of<ProfileProvider>(context, listen: false)
            .updateProfileImage(base64Image);
        // Notifica que a imagem foi atualizada
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
    widget.onMenuItemSelected(item); // Chama o callback para atualizar a página
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    double scaleFactor =
        (screenWidth / 1920).clamp(0.5, 1.0); // ajusta o fator de escala
    double fontSize(double size) => size * scaleFactor;
    double iconSize(double size) => size * scaleFactor;
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
                            fontSize: fontSize(35),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                  // child: Container(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 10.sp),
                  //     child: Row(
                  //       children: [
                  //         Container(
                  //           height: 70 * scaleFactor,
                  //           width: 70 * scaleFactor,
                  //           decoration: BoxDecoration(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(10)),
                  //           ),
                  //           child: profileProvider.profileImageBase64 !=
                  //                   null
                  //               ? Image.memory(
                  //                   base64Decode(profileProvider
                  //                       .profileImageBase64!),
                  //                   fit: BoxFit.cover,
                  //                 )
                  //               : Center(
                  //                   child: Text(
                  //                     'Add Image',
                  //                     style: TextStyle(color: Colors.white),
                  //                   ),
                  //                 ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.only(left: 10.sp),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 widget.userName,
                  //                 style: GoogleFonts.poppins(
                  //                   color: Colors.white,
                  //                   fontSize: fontSize(22.sp),
                  //                   fontWeight: FontWeight.w800,
                  //                 ),
                  //               ),
                  //               Opacity(
                  //                 opacity: 0.70,
                  //                 child: Text(
                  //                   widget.userEmail,
                  //                   style: GoogleFonts.poppins(
                  //                     color: Colors.white,
                  //                     fontSize: fontSize(17.sp),
                  //                     fontWeight: FontWeight.w200,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ),
                _buildActionButton(
                  Icons.view_quilt_rounded,
                  'Dashboard',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'DashboardMaster',
                  onPressed: () {
                    _handleMenuItemSelected('DashboardMaster');
                  },
                ),

                _buildActionButton(
                  Icons.supervisor_account_rounded,
                  'Integration',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'Integration',
                  onPressed: () {
                    _handleMenuItemSelected('Integration');
                  },
                ),
                _buildActionButton(
                  Icons.sms,
                  'Comentários',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'Dashboard',
                  onPressed: () {
                    _handleMenuItemSelected('Dashboard');
                  },
                ),
                _buildActionButton(
                  FontAwesomeIcons.bullhorn,
                  'Broadcast',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'ProfileUser',
                  onPressed: () {
                    _handleMenuItemSelected('ProfileUser');
                  },
                ),
                _buildActionButton(
                  Icons.person,
                  'Business',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'business',
                  onPressed: () {
                    _handleMenuItemSelected('business');
                  },
                ),
                _buildActionButton(
                  PhosphorIcons.flag_banner,
                  'Adversiting',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'Adversiting',
                  onPressed: () {
                    _handleMenuItemSelected('Adversiting');
                  },
                ),
                _buildActionButton(
                  Icons.person,
                  'Users',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'users',
                  onPressed: () {
                    _handleMenuItemSelected('users');
                  },
                ),
                _buildActionButton(
                  FontAwesomeIcons.phone,
                  "Calls",
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == '',
                  onPressed: () {
                    _handleMenuItemSelected('');
                  },
                ),
                _buildActionButton(
                  FontAwesomeIcons.arrowTrendUp,
                  "Surveys",
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'Surveys',
                  onPressed: () {
                    _handleMenuItemSelected('Surveys');
                  },
                ),
                _buildActionButton(
                  Icons.account_box_outlined,
                  'Logins',
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'tatateste',
                  onPressed: () {
                    _handleMenuItemSelected('tatateste');
                  },
                ),
                // _buildActionButton(
                //   Icons.view_carousel,
                //   "Stories",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'Stories',
                //   onPressed: () {
                //     _handleMenuItemSelected('Stories');
                //   },
                // ),
                // _buildActionButton(
                //   Icons.settings,
                //   "Landing Page",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'Landing Page',
                //   onPressed: () {
                //     _handleMenuItemSelected('Landing Page');
                //   },
                // ),
                // _buildActionButton(
                //   Icons.app_shortcut,
                //   "Site Images ",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'App Update',
                //   onPressed: () {
                //     _handleMenuItemSelected('App Update');
                //   },
                // ),
                // _buildActionButton(
                //   Icons.circle_notifications,
                //   "Notifications",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'Notifications',
                //   onPressed: () {
                //     _handleMenuItemSelected('Notifications');
                //   },
                // ),
                // _buildActionButton(
                //   Icons.bar_chart,
                //   "SEO",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'SEO',
                //   onPressed: () {
                //     _handleMenuItemSelected('SEO');
                //   },
                // ),
                // _buildActionButton(
                //   Icons.help_center,
                //   "Site Help & Terms ",
                //   scaleFactor: scaleFactor,
                //   isSelected: _selectedMenuItem == 'Site Help & Terms ',
                //   onPressed: () {
                //     _handleMenuItemSelected('Site Help & Terms ');
                //   },
                // ),
                _buildActionButton(
                  Icons.logout,
                  "Logout",
                  scaleFactor: scaleFactor,
                  isSelected: _selectedMenuItem == 'Logout',
                  onPressed: () {
                    _handleMenuItemSelected('Logout');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label, {
    required bool isSelected,
    required double scaleFactor,
    required VoidCallback onPressed,
  }) {
    bool _isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _isHovered = true;
            });
          },
          onExit: (event) {
            setState(() {
              _isHovered = false;
            });
          },
          child: InkWell(
            onTap: onPressed,
            child: Container(
              color: isSelected
                  ? Color(0xff051309)
                  : _isHovered
                      ? Color.fromARGB(24, 255, 255, 255)
                      : Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(left: 40.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: label == "Logout"
                          ? Colors.red[400]
                          : (isSelected || _isHovered)
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 255, 255, 255)
                                  .withOpacity(0.7),
                      size: 23.sp,
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.sp),
                      child: Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: label == "Logout"
                              ? Colors.red[400]
                              : (isSelected || _isHovered)
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.white.withOpacity(0.7),
                          fontSize: 20.sp,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.w200,
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
      },
    );
  }
}
