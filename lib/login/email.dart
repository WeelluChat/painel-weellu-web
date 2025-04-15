import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitor_site_weellu/models/auth.dart';
import 'package:monitor_site_weellu/rotas/apiservice.dart';
import 'package:monitor_site_weellu/screens/dashboardmaster/dashboardtata.dart';

class LoginEmail extends StatefulWidget {
  final Function(String) onEmailVerified;

  const LoginEmail({super.key, required this.onEmailVerified});

  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isPasswordValid = false;
  bool isPasswordChecked = false;
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

  Future<void> login(String email, String password) async {
    final responseData = await apiService.login(email, password);
    if (responseData != null && responseData['user'] != null) {
      final user = UserModel.fromJson(responseData['user']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => dashdotata(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email ou senha incorretos'),
        ),
      );
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Image.asset('assets/weellu.png'),
                ),
                Text(
                  'Weellu',
                  style: GoogleFonts.ubuntu(
                      color: Color.fromARGB(255, 6, 85, 63),
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Bem-vindo ao Painel! Insira seu Login.',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: 0.50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    border: Border.all(
                      color: Color.fromARGB(255, 100, 97, 97),
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
                      Icon(Icons.mail, color: const Color.fromARGB(255, 110, 109, 109),),
                      Container(
                        color: const Color.fromARGB(255, 242, 242, 242),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10.0),
                              //   child: Text(
                              //     'Endereço de Email',
                              //     style: GoogleFonts.poppins(
                              //       color: Color.fromARGB(255, 255, 255, 255),
                              //       fontSize: 17,
                              //       fontWeight: FontWeight.w500,
                              //       height: 0,
                              //       letterSpacing: 0.50,
                              //     ),
                              //   ),
                              // ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: const Color.fromARGB(255, 25, 95, 40),
                                    selectionColor: Colors.green
                                  )
                                ),
                                child: TextFormField(
                                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                                  controller: emailController,
                                  decoration:
                                      InputDecoration(border: InputBorder.none, hintText: 'Email', ),
                                  onChanged: (value) {
                                    verifyEmail(value);
                                  },
                                ),
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
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    border: Border.all(
                      color: Color.fromARGB(255, 102, 99, 99),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Icon(Icons.lock, color: const Color.fromARGB(255, 104, 103, 103),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: Container(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          height: 55,
                          width: 1,
                        ),
                      ),
                      Container(
                        // color: Colors.amber,
                        // height: 90,
                        width: 330,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10.0),
                              //   child: Text(
                              //     'Senha',
                              //     style: GoogleFonts.poppins(
                              //       color: Color.fromARGB(255, 255, 255, 255),
                              //       fontSize: 17,
                              //       fontWeight: FontWeight.w500,
                              //       height: 0,
                              //       letterSpacing: 0.50,
                              //     ),
                              //   ),
                              // ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: const Color.fromARGB(255, 24, 92, 27),
                                    selectionColor: Colors.green
                                  )
                                ),
                                child: TextFormField(
                                  
                                  style: GoogleFonts.poppins(color: Colors.white,
                                  fontSize: 20),
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration:
                                      InputDecoration(border: InputBorder.none,hintText: 'Senha'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                      )
                    ],
                  ),
                ),
                if (isPasswordChecked)
                  Icon(
                    isPasswordValid ? Icons.check_circle : Icons.cancel,
                    color: isPasswordValid ? Colors.green : Colors.red,
                    size: 30,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF003526),
                    Color(0xFF00A86B),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                color: isEmailValid ? Color(0xFF003526) : Color(0xFF003526),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: 470,
              height: 70,
              child: TextButton(
                onPressed: () async {
                  isEmailValid
                      ? () {
                          widget.onEmailVerified(emailController.text);
                        }
                      : null;
                  await login(emailController.text, passwordController.text);
                },
                child: Center(
                  child: Text(
                    'Login',
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
