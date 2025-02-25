import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageBusines extends StatefulWidget {
  const PageBusines({super.key});

  @override
  State<PageBusines> createState() => _PageBusinesState();
}

class _PageBusinesState extends State<PageBusines> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  ContainerStyler(
                      conteudo: Center(
                        child: Text(
                          '01',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      flex: 2),
                  ContainerStyler(
                    flex: 2,
                    conteudo: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.sp, vertical: 5.sp),
                      child: Container(
                        // width: 10.sp,
                        // height: 40.sp,
                        decoration: ShapeDecoration(
                          color: Color(0xFF313131),
                          shape: OvalBorder(
                            side: BorderSide(
                              width: 1.05,
                              color: Color(0xFF686869),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            PhosphorIcons.activity,
                            color: Colors.amber,
                            size: 25.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ContainerStyler(
                      flex: 8,
                      conteudo: Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Loja do Fulano Variedades',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )),
                  ContainerStyler(
                      flex: 14,
                      conteudo: Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'financeiro@apexnet.com',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      )),
                  ContainerStyler(
                    flex: 2,
                    conteudo: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.delete,
                          size: 25.sp,
                          color: Colors.red,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget ContainerStyler({required flex, required Widget conteudo}) {
  return Expanded(
    flex: flex,
    child: Container(
      // width: 110,
      height: 60.sp,
      decoration: ShapeDecoration(
        color: Color(0xFF1F1F1F),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Color(0xFF686869),
          ),
        ),
      ),
      child: conteudo,
    ),
  );
}
