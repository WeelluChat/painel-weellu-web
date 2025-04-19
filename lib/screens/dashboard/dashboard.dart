import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:monitor_site_weellu/screens/dashboard/ChartMedias.dart';

import 'modulo_cards_country.dart';
import 'modulo_cards_users.dart';
import 'modulo_map_world.dart';

class DashMaster extends StatefulWidget {
  const DashMaster({super.key});

  @override
  State<DashMaster> createState() => _DashMasterState();
}

class _DashMasterState extends State<DashMaster> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyWindowsScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
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
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          height: 0,
                          letterSpacing: 0.50,
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
                  Wrap(
                    direction: Axis.horizontal,
                    children: [ModuloCardsUsers()],
                  ),
                  ModuloMapWorld(),
                  ModuloCardsCountry(),
                  Chartmedias(),
                ],
              ),
            ),
          ],
        ),
      ),
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
