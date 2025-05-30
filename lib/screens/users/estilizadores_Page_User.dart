import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/screens/profileUsers/profile_user.dart';
import 'package:monitor_site_weellu/screens/users/alert_Dialog.dart';

Widget containerFlexHeader({required int value, required String label}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xff212121),
        border: Border.all(
          width: 0.08.sp,
          color: Color(0xff979797),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget containerActions(
    {required int value,
    required String userId,
    required BuildContext context}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.08.sp,
          color: Color(0xff979797),
        ),
      ),
      padding: EdgeInsets.all(5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.visibility,
              color: Colors.white,
              size: 22.sp,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileUser(
                      userId: userId), // Navegando para a tela ProfileUser
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.lock_open,
              color: Colors.green,
              size: 22.sp,
            ),
            onPressed: () {
              // Ação para autorizar
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 22.sp,
            ),
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialogDeleteUser(userId: userId,);
              },);
            },
          ),
        ],
      ),
    ),
  );
}

Widget containerFlex({
  required int value,
  required String label,
  bool isNew = false, // banner de novo
}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.08.sp,
          color: Color(0xff979797),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
              right: 0,
              top: 0,
              child: isNew
                  ? Container(
                      padding: EdgeInsets.all(5.sp),
                      color: Colors.green,
                      child: Text(
                        "NEW",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp),
                      ),
                    )
                  : SizedBox.shrink()),
          Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                fontSize: 15.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget containerFlagColumn({required String countryCode, required int value}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.08.sp,
          color: Color(0xff979797),
        ),
      ),
      child: Center(
          child: countryCode.isNotEmpty
              ? CountryFlag.fromCountryCode(
                  countryCode,
                  height: 25.sp,
                  width: 35.sp,
                  // Borda arredondada para a bandeira
                )
              : Icon(
                  Icons.flag,
                  color: Colors.grey,
                ) // se o usuario vir com o pais nulo
          ),
    ),
  );
}

