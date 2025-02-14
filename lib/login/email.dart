import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';

class LoginEmail extends StatefulWidget {
  final Function(String) onEmailVerified;

  const LoginEmail({super.key, required this.onEmailVerified});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'http://192.168.99.239:3000');
  }

  Future<void> verifyEmail(String email) async {
    try {
      final bool exists = await apiService.verifyEmail(email);
      setState(() {
        isEmailValid = exists;
      });
    } catch (e) {
      setState(() {
        isEmailValid = false;
      });
    }
  }

  // Future<void> verifyEmail(String email) async {
  //   final response = await http
  //       .get(Uri.parse('http://192.168.99.239:3000/verify-email?email=$email'));
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isEmailValid = jsonDecode(response.body)['exists'];
  //     });
  //   } else {
  //     setState(() {
  //       isEmailValid = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bem vindo!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Opacity(
              opacity: 0.50,
              child: Text(
                'Bem Vindo, Por favor insira seu login ',
                style: TextStyle(
                  color: Color(0xFF404852),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.50,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD9D9D9),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: 450,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      height: 60,
                      width: 210,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Color(0xffFFFFFF)),
                        onPressed: () {},
                        child: Text(
                          "Login",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Container(
                      height: 60,
                      width: 210,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Registrar",
                          style: GoogleFonts.ubuntu(
                              color: Colors.black, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFFD9D9D9),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  width: 450,
                  height: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.mail),
                      Container(
                        color: Colors.black,
                        height: 55,
                        width: 1,
                      ),
                      Container(
                        // color: Colors.red,
                        height: 90,
                        width: 330,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    'Endereço de Email',
                                    style: TextStyle(
                                      color: Color(0xFF404852),
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: 0.50,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                onChanged: (value) {
                                  verifyEmail(value);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      if (isEmailValid)
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: isEmailValid ? Color(0xFF003526) : Color(0xFF003526),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: 450,
              height: 70,
              child: TextButton(
                onPressed: isEmailValid
                    ? () {
                        widget.onEmailVerified(emailController.text);
                      }
                    : null,
                child: Center(
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
