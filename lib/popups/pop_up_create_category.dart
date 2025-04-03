import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopUpCreateCategory extends StatefulWidget {
  final String nameCategoty;
  const PopUpCreateCategory({super.key, required this.nameCategoty});

  @override
  State<PopUpCreateCategory> createState() => _PopUpCreateCategoryState();
}

class _PopUpCreateCategoryState extends State<PopUpCreateCategory> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Expanded(
            child: Container(
              // width: 400.sp,
              height: 70.sp,
              decoration: ShapeDecoration(
                color: const Color(0xFF313131),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFF4BC57A),
                  ),
                  borderRadius: BorderRadius.circular(10.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                child: Row(
                  children: [
                    Icon(
                      Icons.exposure_plus_1,
                      size: 40.sp,
                      color: Color(0xff4CC67A),
                    ),
                    SizedBox(
                      width: 10.sp,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '“${widget.nameCategoty}”',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' é uma nova categoria!',
                            style: TextStyle(
                              color: const Color(0xFFAFB3C2),
                              fontSize: 15.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
