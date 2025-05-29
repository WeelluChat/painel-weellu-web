import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogDeleteUser extends StatefulWidget {
  const AlertDialogDeleteUser({super.key});

  @override
  State<AlertDialogDeleteUser> createState() => _AlertDialogDeleteUserState();
}

class _AlertDialogDeleteUserState extends State<AlertDialogDeleteUser> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Center(child: Text('Excluir Usuario', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              'A exclusão do usuário apagará todos os seus dados, de forma irreversível.', style: TextStyle(color: Colors.white),),
              Text('Tem certeza da exclusão?', style: TextStyle(color: Colors.white)),
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
                        onPressed: () {},
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
                        onPressed: () {},
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20),
                        ))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
