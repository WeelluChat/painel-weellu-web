import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/dashboardmaster/dashboardtata.dart';
import '../models/auth.dart';
import '../rotas/apiservice.dart';

class LoginSenha extends StatefulWidget {
  final String email;

  const LoginSenha({super.key, required this.email});

  @override
  State<LoginSenha> createState() => _LoginSenhaState();
}

class _LoginSenhaState extends State<LoginSenha> {
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordValid = false;
  bool isPasswordChecked = false;
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl: 'http://192.168.99.239:3000');
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Digite sua senha',
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
                'Email: ${widget.email}',
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.lock),
                      ),
                      Container(
                        color: Colors.black,
                        height: 55,
                        width: 1,
                      ),
                      Container(
                        // color: Colors.amber,
                        // height: 90,
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
                                    'Senha',
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
                                obscureText: true,
                                controller: passwordController,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
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
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: isPasswordValid ? Color(0xFF003526) : Color(0xFF003526),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              width: 450,
              height: 70,
              child: TextButton(
                onPressed: () async {
                  // Chame a função de login ao clicar no botão
                  await login(widget.email, passwordController.text);
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
