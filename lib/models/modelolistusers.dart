import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _containerFlex({required int value, required String label}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Color(0xff979797),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Widget _containerFlexUsers({required int value, required String label}) {
  return Expanded(
    flex: value,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Color(0xff979797),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
