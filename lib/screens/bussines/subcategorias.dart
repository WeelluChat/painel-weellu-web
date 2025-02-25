import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/screens/bussines/addCategorias.dart';
import 'package:monitor_site_weellu/screens/bussines/page_busines.dart';

class Subcategorias extends StatefulWidget {
  const Subcategorias({super.key});

  @override
  State<Subcategorias> createState() => _SubcategoriasState();
}

class _SubcategoriasState extends State<Subcategorias> {
  Widget _ContainerStyler({required double width, required Widget conteudo}) {
    return Container(
      width: width,
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
    );
  }

  Widget _HeaderContainerStyler({
    double padding = 0,
    required double width,
    required String text,
    Alignment alignment = Alignment.center,
    double BorderLeft = 0,
    double BorderRight = 0,
  }) {
    return Container(
      width: width,
      height: 60.sp,
      decoration: ShapeDecoration(
        color: Color(0xFF313131),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(BorderLeft),
              topRight: Radius.circular(BorderRight)),
          side: BorderSide(width: 1, color: Color(0xFF53555B)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: padding),
        child: Align(
          alignment: alignment,
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF7D7F87),
              fontSize: 20.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Container(
          // width: 1150.sp,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 500.sp,
                    // height: 50.sp,
                    decoration: ShapeDecoration(
                      color: Color(0xFF1F1F1F),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.75, color: Color(0xFF53555B)),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Pesquisar"),
                    ),
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  Container(
                    width: 170.sp,
                    height: 50.sp,
                    decoration: ShapeDecoration(
                      color: Color(0xFF202020),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.50, color: Color(0xFF7D7F87)),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.sp,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierColor: Color.fromARGB(141, 87, 87, 87),
                        context: context,
                        builder: (context) {
                          return Addcategorias();
                        },
                      );
                    },
                    child: Container(
                      width: 120.sp,
                      height: 50.sp,
                      decoration: ShapeDecoration(
                        color: Color(0xFF009D6D),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.sp)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 25.sp,
                          ),
                          Text(
                            'Add',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 17.sp,
                              // fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.sp,
              ),
              Row(
                children: [
                  _HeaderContainerStyler(
                      width: 102.sp, text: "#", BorderLeft: 5.sp),
                  _HeaderContainerStyler(width: 100.sp, text: "Ícone"),
                  _HeaderContainerStyler(width: 100.sp, text: "Cor"),
                  _HeaderContainerStyler(
                      padding: 20.sp,
                      width: 300.sp,
                      text: "Subcategories",
                      alignment: Alignment.centerLeft),
                  _HeaderContainerStyler(
                    width: 100.sp,
                    text: "Qnt",
                  ),
                  _HeaderContainerStyler(
                      width: 310.sp,
                      text: "Categories",
                      padding: 20.sp,
                      alignment: Alignment.centerLeft),
                  _HeaderContainerStyler(
                      width: 145.sp,
                      text: "Ações",
                      padding: 20.sp,
                      alignment: Alignment.centerLeft)
                ],
              ),
              Row(
                children: [
                  _ContainerStyler(
                    width: 102.sp,
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
                  ),
                  _ContainerStyler(
                    width: 100.sp,
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
                  _ContainerStyler(
                    width: 100.sp,
                    conteudo: Center(
                      child: Text(
                        'FF5437',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  _ContainerStyler(
                    width: 300.sp,
                    conteudo: Padding(
                      padding: EdgeInsets.only(left: 20.sp),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Pizza',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _ContainerStyler(
                    width: 100.sp,
                    conteudo: Center(
                      child: Text(
                        '78',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  _ContainerStyler(
                    width: 310.sp,
                    conteudo: Padding(
                      padding: EdgeInsets.only(left: 20.sp),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Alimentation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _ContainerStyler(
                    width: 145.sp,
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
