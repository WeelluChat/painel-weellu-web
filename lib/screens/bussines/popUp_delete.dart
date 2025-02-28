import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/screens/bussines/business.dart';
import 'package:monitor_site_weellu/utilitarios/datanotfier.dart';

class PopupDelete extends StatefulWidget {
  final String idCategoria;
  // final VoidCallback ontap;
  const PopupDelete(
      {super.key,
      // required this.ontap,
      required this.idCategoria});

  @override
  State<PopupDelete> createState() => _PopupDeleteState();
}

class _PopupDeleteState extends State<PopupDelete> {
  final DataNotfier dataNotfier = DataNotfier();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: 700.sp,
            height: 280.sp,
            decoration: ShapeDecoration(
              color: Color(0xFF181818),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.sp),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.sp),
              child: Column(
                children: [
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                  SizedBox(
                    width: 458.sp,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Are you sure you want to delete this category? All products in it ',
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'were left without a category',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: ' after deletion.',
                            style: TextStyle(
                              color: Color(0xFF8F8F8F),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 270.sp,
                          height: 45.sp,
                          decoration: ShapeDecoration(
                            color: Color(0xFF575757),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.sp),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      InkWell(
                        onTap: () {
                          dataNotfier.deleteCategory(widget.idCategoria);

                          Navigator.pop(context, true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Categoria excluída com sucesso!')),
                          );
                          // dataNotfier.loadData();
                          // dataNotfier.fetchSubcategoriesModel();
                        },
                        // onTap: widget.ontap,
                        child: Container(
                          width: 270.sp,
                          height: 45.sp,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFF5151),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.sp),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Excluir',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
