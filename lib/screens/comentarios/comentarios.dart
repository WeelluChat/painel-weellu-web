import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'card_comenter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Flex(
          direction: Axis.vertical,
          children: [
            Padding(
              padding: EdgeInsets.all(30.sp),
              child: Container(
                height: 90.sp,
                width: 1600.sp,
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
                        'Comentários',
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
            Expanded(
              flex: 4,
              child: Container(
                // color: Colors.amber,
                child: Column(
                  children: [
                    CardComenter(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
