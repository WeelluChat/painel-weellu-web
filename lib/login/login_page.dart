import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/login/email.dart';

import 'senha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showEmail = true;
  String email = '';

  void onEmailVerified(String verifiedEmail) {
    setState(() {
      email = verifiedEmail;
      showEmail = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 255, 255, 255),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/frame.png'), fit: BoxFit.cover)),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                if (MediaQuery.of(context).size.width > 900)
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(
                                'assets/weellu1.jpg',
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoginEmail(onEmailVerified: onEmailVerified),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
