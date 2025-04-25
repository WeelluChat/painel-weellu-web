import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:country_flags/country_flags.dart';
import 'package:intl/intl.dart';
import 'package:monitor_site_weellu/screens/dashboard/modulo_cards_users.dart';

class ModuloUserProfile extends StatefulWidget {
  final String userId;

  const ModuloUserProfile({required this.userId});

  @override
  State<ModuloUserProfile> createState() => _ModuloUserProfileState();
}

class _ModuloUserProfileState extends State<ModuloUserProfile> {
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.weellu.com/api/v1/admin-panel/user/info/${widget.userId}'),
      headers: {
        'admin-key': 'super_password_for_admin',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data']['userInfo'] ?? {};
    } else {
      throw Exception('Failed to load user data');
    }
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double scaleFactor = screenWidth / 1920;
    final double cardWidth = screenWidth * 0.17; // 17% da largura da tela
    final double cardHeight = screenHeight * 0.19; // 19% da altura da tela
    final double fontSizeTitle = 25.sp;
    final double fontSizeText = 18.sp;

    return FutureBuilder<Map<String, dynamic>>(
      future: _userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final user = snapshot.data!;
        return Container(
          height: 500.sp,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 29, 29),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: _containerModel(
                                    cor: Colors.white,
                                    icone: Icons.arrow_back_outlined),
                              ),
                              Row(
                                children: [
                                  _containerModel(
                                      cor: Color(0xff00F260),
                                      icone: Icons.edit),
                                  SizedBox(width: 10.sp),
                                  _containerModel(
                                      cor: Color(0xff00F260),
                                      icone: Icons.lock),
                                  SizedBox(width: 10.sp),
                                  _containerModel(
                                      cor: Color(0xffE42525),
                                      icone: Icons.delete),
                                  SizedBox(width: 10.sp),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.sp),
                          child: Container(
                            height: 150.sp,
                            width: 150.sp,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://weellu-chat.s3.us-east-2.amazonaws.com/${user['userImages']['fullImage'] ?? ''}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 150.sp,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.sp),
                          child: Text(
                            user['fullName'] ?? 'Name not available',
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeTitle),
                          ),
                        ),
                        _rowTextModel(
                            texto: "E-mail",
                            texto2: user['email'] ?? 'N/A',
                            fontSize: fontSizeText),
                        _textCountryFlag(
                            texto: 'País',
                            pais: user['countryId']?['code'] ?? '',
                            fontSize: fontSizeText),
                        _rowTextModel(
                            texto: "Criado em:",
                            texto2: formatDate(user['createdAt'] ?? ''),
                            fontSize: fontSizeText),
                        _rowTextModel(
                            texto: "Visto por último:",
                            texto2: formatDate(user['lastSeenAt'] ?? ''),
                            fontSize: fontSizeText),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Container(
                    height: 500.sp,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 29, 29),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        CardsUser(
                            CorContinerGeral: Color(0xff212121),
                            Valor: '0',
                            MiniContainer: azulFraco,
                            Icone: Icons.sms,
                            ColorIcon: azul,
                            Texto: "Dia",
                            Texto2: 'Total\nMessage',
                            Cor: azul,
                            CorFraca: azulFraco,
                            width: cardWidth,
                            height: cardHeight),
                        CardsUser(
                            CorContinerGeral: Color(0xff212121),
                            Valor: '0',
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
                            CorContinerGeral: Color(0xff212121),
                            Valor: '0',
                            MiniContainer: vermelhoFraco,
                            Icone: Icons.task,
                            ColorIcon: vermelho,
                            Texto: "Total",
                            Texto2: 'Project',
                            Cor: vermelho,
                            CorFraca: vermelhoFraco,
                            width: cardWidth,
                            height: cardHeight),
                        CardsUser(
                            CorContinerGeral: Color(0xff212121),
                            Valor: '0',
                            MiniContainer: lilasFraco,
                            Icone: Icons.task,
                            ColorIcon: lilas,
                            Texto: "Total",
                            Texto2: 'Chat\nPrivate',
                            Cor: lilas,
                            CorFraca: lilasFraco,
                            width: cardWidth,
                            height: cardHeight),
                        CardsUser(
                            CorContinerGeral: Color(0xff212121),
                            Valor: '0',
                            MiniContainer: RosaFraco,
                            Icone: Icons.group,
                            ColorIcon: Rosa,
                            Texto: "Total",
                            Texto2: 'Groups',
                            Cor: Rosa,
                            CorFraca: RosaFraco,
                            width: cardWidth,
                            height: cardHeight),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _containerModel({required Color cor, required IconData icone}) {
  return Container(
    height: 35.sp,
    width: 35.sp,
    decoration: BoxDecoration(
      border: Border.all(color: cor),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icone, color: cor),
  );
}

Widget _rowTextModel(
    {required String texto, required String texto2, required double fontSize}) {
  return Padding(
    padding: EdgeInsets.all(10.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texto,
          style: GoogleFonts.ubuntu(
              color: Color(0xff979797),
              fontWeight: FontWeight.w500,
              fontSize: fontSize),
        ),
        Text(
          texto2,
          style: GoogleFonts.ubuntu(
              color: Color(0xff979797),
              fontWeight: FontWeight.w500,
              fontSize: fontSize),
        ),
      ],
    ),
  );
}

Widget _textCountryFlag(
    {required String texto, required String pais, required double fontSize}) {
  return Padding(
    padding: EdgeInsets.all(10.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          texto,
          style: GoogleFonts.ubuntu(
              color: Color(0xff979797),
              fontWeight: FontWeight.w500,
              fontSize: fontSize),
        ),
        pais.isNotEmpty
            ? CountryFlag.fromCountryCode(
                pais,
                height: 25.sp,
                width: 35.sp,
              )
            : Icon(
                Icons.flag,
                color: Colors.grey,
              )
      ],
    ),
  );
}
