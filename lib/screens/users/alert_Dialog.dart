import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:monitor_site_weellu/screens/integracao/integracao.dart';

class AlertDialogDeleteUser extends StatefulWidget {
  const AlertDialogDeleteUser({super.key, required this.userId});
  final String userId;
  @override
  State<AlertDialogDeleteUser> createState() => _AlertDialogDeleteUserState();
}

class _AlertDialogDeleteUserState extends State<AlertDialogDeleteUser> {
  String delete = '';
  @override
  void initState() {
    print(widget.userId);
    super.initState();
  }

  deleteUser() async {
  final url = Uri.parse(
    'https://api.weellu.com/api/v1/admin-panel/user/info/${widget.userId}');
  
  try {
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'admin-key': 'super_password_for_admin'
      },
      body: json.encode({
        "deletedAt": DateTime.now().toUtc().toIso8601String() // Data atual corrigida
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("Sucesso: ${response.body}");
      return true;
    } else {
      print("Erro ${response.statusCode}: ${response.body}");
      return false;
    }
  } catch (e) {
    print("Erro na requisição: $e");
    return false;
  }
}

  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Center(
          child: Text(
        'Excluir Usuario',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, color: Colors.white),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'A exclusão do usuário apagará todos os seus dados, de forma irreversível.',
            style: TextStyle(color: Colors.white),
          ),
          Text('Tem certeza da exclusão?',
              style: TextStyle(color: Colors.white)),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                        onPressed: () async {
                          await deleteUser();
                          if (!mounted) return;
                          Navigator.pop(context, "Excluido!");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuário excluído com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          'Excluir',
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20),
                        ))),
                SizedBox(
                  width: 20,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, "Cancelado!");
                        },
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
