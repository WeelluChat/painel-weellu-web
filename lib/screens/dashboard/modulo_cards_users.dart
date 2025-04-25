import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuloCardsUsers extends StatefulWidget {
  const ModuloCardsUsers({super.key});

  @override
  State<ModuloCardsUsers> createState() => _ModuloCardsUsersState();
}

final Color azul = Color.fromARGB(255, 38, 151, 255);
final Color azulFraco = Color.fromARGB(35, 38, 151, 255);
final Color verde = Color.fromARGB(255, 0, 242, 96);
final Color verdeFraco = Color.fromARGB(35, 0, 242, 96);
final Color amarelo = Color.fromARGB(255, 242, 255, 0);
final Color amareloFraco = Color.fromARGB(35, 242, 255, 0);
final Color laranja = Color.fromARGB(255, 255, 161, 19);
final Color laranjaFraco = Color.fromARGB(35, 255, 161, 19);
final Color vermelho = Color.fromARGB(255, 228, 37, 37);
final Color vermelhoFraco = Color.fromARGB(35, 228, 37, 37);
final Color Rosa = Color.fromARGB(255, 233, 30, 99);
final Color RosaFraco = Color.fromARGB(35, 233, 30, 99);
final Color lilas = Color.fromARGB(255, 113, 86, 163);
final Color lilasFraco = Color.fromARGB(35, 113, 86, 163);
final Color roxo = Color.fromARGB(255, 147, 114, 208);
final Color roxoFraco = Color.fromARGB(35, 147, 114, 208);

class _ModuloCardsUsersState extends State<ModuloCardsUsers> {
  int online = 0;
  int messages = 0;

  @override
  void initState() {
    super.initState();
    fetchApiData();
  }

  Future<void> fetchApiData() async {
    final response = await http.get(
      Uri.parse('https://api.weellu.com/api/v1/admin-panel/dashboard'),
      headers: {
        'admin-key': 'super_password_for_admin',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body);

      setState(() {
        online = data['data']['userData']['online'];
        messages = data['data']['messagesCounter']['messages'];
      });
    } else {
      // Lidar com erros de resposta da API
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cardWidth = screenWidth * 0.17; // 30% da largura da tela
    final double cardHeight = screenHeight * 0.19; // 25% da altura da tela

    return Wrap(
      direction: Axis.horizontal,
      children: [
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: '0',
            MiniContainer: azulFraco,
            Icone: Icons.person,
            ColorIcon: azulFraco,
            Texto: "Ano",
            Texto2: "Users",
            Cor: azul,
            CorFraca: azulFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: online.toString(),
            MiniContainer: verdeFraco,
            Icone: Icons.person_3_sharp,
            ColorIcon: verde,
            Texto: 'Dia',
            Texto2: "Online\nUsers",
            Cor: verde,
            CorFraca: verdeFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: messages.toString(),
            MiniContainer: amareloFraco,
            Icone: Icons.sms,
            ColorIcon: amarelo,
            Texto: 'Total',
            Texto2: 'Total\nMessage',
            Cor: amarelo,
            CorFraca: amareloFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: "0",
            MiniContainer: laranjaFraco,
            Icone: Icons.group,
            ColorIcon: laranja,
            Texto: "Total",
            Texto2: 'Groups',
            Cor: laranja,
            CorFraca: laranjaFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: "0",
            MiniContainer: vermelhoFraco,
            Icone: Icons.campaign,
            ColorIcon: vermelho,
            Texto: "Total",
            Texto2: 'Broadcast',
            Cor: vermelho,
            CorFraca: vermelhoFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: '0',
            MiniContainer: RosaFraco,
            Icone: Icons.language,
            ColorIcon: Rosa,
            Texto: 'Total',
            Texto2: "Total\nCountries",
            Cor: Rosa,
            CorFraca: RosaFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: '0',
            MiniContainer: lilasFraco,
            Icone: Icons.task,
            ColorIcon: lilas,
            Texto: "Total",
            Texto2: 'Project',
            Cor: lilas,
            CorFraca: lilasFraco,
            width: cardWidth,
            height: cardHeight),
        CardsUser(
            CorContinerGeral: Color.fromARGB(255, 60, 54, 54),
            Valor: '0',
            MiniContainer: roxoFraco,
            Icone: Icons.add_task,
            ColorIcon: roxo,
            Texto: 'Total',
            Texto2: 'Task',
            Cor: roxo,
            CorFraca: roxoFraco,
            width: cardWidth,
            height: cardHeight)
      ],
    );
  }
}

Widget CardsUser(
    {required String Valor,
    required Color MiniContainer,
    required IconData Icone,
    required Color ColorIcon,
    required String Texto,
    required String Texto2,
    required Color Cor,
    required Color CorFraca,
    required double width,
    required double height,
    required Color CorContinerGeral}) {
  return Padding(
    padding: EdgeInsets.only(left: width * 0.03, top: height * 0.05),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 19, 17, 17),
        borderRadius: BorderRadius.all(
          Radius.circular(width * 0.03),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MiniContainer,
                        borderRadius: BorderRadius.all(
                          Radius.circular(width * 0.03),
                        ),
                      ),
                      height: height * 0.3,
                      width: width * 0.2,
                      child: Icon(
                        Icone,
                        color: Cor,
                        size: width * 0.1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.05),
                      child: Text(
                        Texto2,
                        style: GoogleFonts.getFont('Poppins',
                            color: Colors.white,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.05),
                      child: Text(
                        Valor,
                        style: GoogleFonts.getFont('Poppins',
                            color: Cor,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      Texto,
                      style: GoogleFonts.getFont('Poppins',
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: height * 0.05),
                    Container(
                      height: height * 0.35,
                      width: width * 0.5,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: 6,
                          minY: 0,
                          maxY: 6,
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 3),
                                FlSpot(1, 1),
                                FlSpot(2, 4),
                                FlSpot(3, 3),
                                FlSpot(4, 2),
                                FlSpot(5, 5),
                              ],
                              isCurved: true,
                              color: Cor,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: width * 0.07,
                    ),
                    SizedBox(
                      height: height * 0.35,
                    )
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: CorFraca,
                borderRadius: BorderRadius.all(
                  Radius.circular(width * 0.03),
                ),
              ),
              height: height * 0.02,
              width: width * 0.85,
            )
          ],
        ),
      ),
    ),
  );
}
