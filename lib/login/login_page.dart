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
      backgroundColor: Color(0xff0000),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        height: constraints.maxHeight *
                            1.0, // 80% da altura da tela disponível
                        // margin: EdgeInsets.all(
                        //     8), // Margem opcional para espaço entre os containers
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    height: 80,
                                    width: 80,
                                    child: Image.asset('assets/weellu.png'),
                                  ),
                                  Text(
                                    'Weellu',
                                    style: GoogleFonts.ubuntu(
                                        color: Color(0xff003526),
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            showEmail
                                ? LoginEmail(onEmailVerified: onEmailVerified)
                                : LoginSenha(email: email),
                            // Login_senha(),
                            Container(
                              // color: Colors.amber,
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.black,
                        height: constraints.maxHeight *
                            1.0, // 80% da altura da tela disponível
                        // margin: EdgeInsets.all(
                        //     8), // Margem opcional para espaço entre os containers
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    height: 80,
                                    width: 80,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // color: Colors.red,
                              height: 500,
                              width: 500,
                              child: Image.asset('assets/weellu_500.png'),
                            ),
                            Container(
                              // color: Colors.amber,
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
