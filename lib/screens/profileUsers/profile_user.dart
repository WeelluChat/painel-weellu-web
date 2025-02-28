import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monitor_site_weellu/screens/profileUsers/modulo_User_profile.dart';
import 'package:monitor_site_weellu/screens/profileUsers/modulo_chart_line.dart';

class ProfileUser extends StatefulWidget {
  final String userId;

  ProfileUser({required this.userId}); // Ensure this parameter exists

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  @override
  Widget build(BuildContext context) {
    print("id do usuario ${widget.userId}");
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyWindowsScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(30.sp),
                  child: Container(
                    height: 90,
                    width: 1600,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.sp),
                          child: Text(
                            'User Profile',
                            style: TextStyle(
                              color: Color(0xFFEAEAF0),
                              fontSize: 40.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.67,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    child: Column(
                  children: [
                    ModuloUserProfile(
                      userId: widget.userId,
                    ),
                    ModuloChartLine(),
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MyWindowsScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // Melhor física para Windows
  }

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.mouse,
      PointerDeviceKind.touch,
      PointerDeviceKind.trackpad,
    };
  }
}
