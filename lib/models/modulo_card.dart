import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'solicitacoes.dart';

class modulo_card extends StatefulWidget {
  const modulo_card({super.key});

  @override
  State<modulo_card> createState() => _modulo_cardState();
}

class _modulo_cardState extends State<modulo_card> {
  final Color amarelo = Color.fromARGB(255, 255, 255, 0);
  final Color amareloFraco = Color.fromARGB(111, 255, 255, 0);
  final Color vermelho = Color.fromARGB(255, 175, 0, 0);
  final Color vermelhoFraco = Color.fromARGB(111, 175, 0, 0);
  final Color verde = Color.fromARGB(255, 0, 242, 97);
  final Color verdeFraco = Color.fromARGB(111, 0, 242, 97);

  Solicitacoes? solicitacoes;

  @override
  void initState() {
    super.initState();
    fetchSolicitacoes().then((data) {
      setState(() {
        solicitacoes = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return solicitacoes == null
        ? Center(child: CircularProgressIndicator())
        : Wrap(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: _buildActionButton(
                  icon: Icons.check,
                  iconColor: verde,
                  containerColor: verdeFraco,
                  progressColor: verde,
                  textValue: verde,
                  label: 'Aprovados',
                  value: solicitacoes!.aprovado.toString(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: _buildActionButton(
                  icon: Icons.close,
                  iconColor: vermelho,
                  containerColor: vermelhoFraco,
                  progressColor: vermelho,
                  textValue: vermelho,
                  label: 'Reprovados',
                  value: solicitacoes!.reprovado.toString(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: _buildActionButton(
                  icon: Icons.timer_outlined,
                  iconColor: amarelo,
                  containerColor: amareloFraco,
                  progressColor: amarelo,
                  textValue: amarelo,
                  label: 'Pendentes',
                  value: solicitacoes!.pendente.toString(),
                ),
              ),
            ],
          );
  }

  Future<Solicitacoes> fetchSolicitacoes() async {
    final response = await http
        .get(Uri.parse('http://192.168.99.239:3000/api/contagem_solicitacoes'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return Solicitacoes.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load solicitations');
    }
  }
}

Widget _buildActionButton({
  required IconData icon,
  required Color iconColor,
  required Color containerColor,
  required Color progressColor,
  required Color textValue,
  required String label,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    width: 300,
    height: 175,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xff292929),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: containerColor,
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.getFont('Poppins',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: textValue,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(50),
              ),
            )
          ],
        )
      ],
    ),
  );
}
