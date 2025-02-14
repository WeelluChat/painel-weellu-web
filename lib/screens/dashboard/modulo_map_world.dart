import 'dart:convert';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModuloMapWorld extends StatefulWidget {
  const ModuloMapWorld({super.key});

  @override
  State<ModuloMapWorld> createState() => _ModuloMapWorldState();
}

class _ModuloMapWorldState extends State<ModuloMapWorld> {
  Map<String, int> userDistribution = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = 'https://api.weellu.com/api/v1/admin-panel/dashboard';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'admin-key': 'super_password_for_admin',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null &&
            data['data'] != null &&
            data['data']['userCountries'] != null) {
          final List<dynamic> countriesData = data['data']['userCountries'];

          Map<String, int> distribution = {};
          for (var countryData in countriesData) {
            final country = countryData['country'];
            final count = countryData['count'];
            if (country != null && count != null) {
              String countryKey = country['code'].toUpperCase();
              distribution[countryKey] = count;
            }
          }

          setState(() {
            userDistribution = distribution;
            print('Distribuição de Usuários: $userDistribution');
          });
        } else {
          print('Dados da resposta não estão no formato esperado.');
        }
      } else {
        print('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar dados: $e');
    }
  }

  Color _getColorForCountry(String countryKey) {
    final userCount = userDistribution[countryKey] ?? 0;
    if (userCount > 100) {
      return Colors.red; // Cor para mais de 100 usuários
    } else if (userCount > 0) {
      return Colors.green; // Cor para usuários
    } else {
      return Colors.grey; // Cor padrão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 500,
        child: SimpleMap(
          instructions: SMapWorld.instructions,
          defaultColor: Colors.grey,
          colors: SMapWorldColors(
            // Define as cores diretamente para todos os países conhecidos
            // Adapte conforme necessário para os países que você precisa
            aF: _getColorForCountry('AF'),
            aL: _getColorForCountry('AL'),
            dZ: _getColorForCountry('DZ'),
            aD: _getColorForCountry('AD'),
            aO: _getColorForCountry('AO'),
            aG: _getColorForCountry('AG'),
            aR: _getColorForCountry('AR'),
            aM: _getColorForCountry('AM'),
            aU: _getColorForCountry('AU'),
            aT: _getColorForCountry('AT'),
            aZ: _getColorForCountry('AZ'),
            bS: _getColorForCountry('BS'),
            bH: _getColorForCountry('BH'),
            bD: _getColorForCountry('BD'),
            bB: _getColorForCountry('BB'),
            bY: _getColorForCountry('BY'),
            bE: _getColorForCountry('BE'),
            bZ: _getColorForCountry('BZ'),
            bJ: _getColorForCountry('BJ'),
            bT: _getColorForCountry('BT'),
            bO: _getColorForCountry('BO'),
            bA: _getColorForCountry('BA'),
            bW: _getColorForCountry('BW'),
            bR: _getColorForCountry('BR'),
            bN: _getColorForCountry('BN'),
            bG: _getColorForCountry('BG'),
            bF: _getColorForCountry('BF'),
            bI: _getColorForCountry('BI'),
            cV: _getColorForCountry('CV'),
            kH: _getColorForCountry('KH'),
            cM: _getColorForCountry('CM'),
            cA: _getColorForCountry('CA'),
            kY: _getColorForCountry('KY'),
            cF: _getColorForCountry('CF'),
            tD: _getColorForCountry('TD'),
            cL: _getColorForCountry('CL'),
            cN: _getColorForCountry('CN'),
            cO: _getColorForCountry('CO'),
            kM: _getColorForCountry('KM'),
            cG: _getColorForCountry('CG'),
            cD: _getColorForCountry('CD'),
            cR: _getColorForCountry('CR'),
            cI: _getColorForCountry('CI'),
            hR: _getColorForCountry('HR'),
            cU: _getColorForCountry('CU'),
            cW: _getColorForCountry('CW'),
            cY: _getColorForCountry('CY'),
            cZ: _getColorForCountry('CZ'),
            dK: _getColorForCountry('DK'),
            dJ: _getColorForCountry('DJ'),
            dM: _getColorForCountry('DM'),
            dO: _getColorForCountry('DO'),
            eC: _getColorForCountry('EC'),
            eG: _getColorForCountry('EG'),
            sV: _getColorForCountry('SV'),
            gQ: _getColorForCountry('GQ'),
            eR: _getColorForCountry('ER'),
            eE: _getColorForCountry('EE'),
            sZ: _getColorForCountry('SZ'),
            eT: _getColorForCountry('ET'),
            fJ: _getColorForCountry('FJ'),
            fI: _getColorForCountry('FI'),
            fR: _getColorForCountry('FR'),
            gA: _getColorForCountry('GA'),
            gM: _getColorForCountry('GM'),
            gE: _getColorForCountry('GE'),
            dE: _getColorForCountry('DE'),
            gH: _getColorForCountry('GH'),
            gI: _getColorForCountry('GI'),
            gR: _getColorForCountry('GR'),
            gD: _getColorForCountry('GD'),
            gT: _getColorForCountry('GT'),
            gN: _getColorForCountry('GN'),
            gW: _getColorForCountry('GW'),
            gY: _getColorForCountry('GY'),
            hT: _getColorForCountry('HT'),
            hN: _getColorForCountry('HN'),
            hK: _getColorForCountry('HK'),
            hU: _getColorForCountry('HU'),
            iS: _getColorForCountry('IS'),
            iN: _getColorForCountry('IN'),
            iD: _getColorForCountry('ID'),
            iR: _getColorForCountry('IR'),
            iQ: _getColorForCountry('IQ'),
            iE: _getColorForCountry('IE'),
            iL: _getColorForCountry('IL'),
            iT: _getColorForCountry('IT'),
            jM: _getColorForCountry('JM'),
            jP: _getColorForCountry('JP'),
            jO: _getColorForCountry('JO'),
            kZ: _getColorForCountry('KZ'),
            kE: _getColorForCountry('KE'),
            kI: _getColorForCountry('KI'),
            kR: _getColorForCountry('KR'),
            kW: _getColorForCountry('KW'),
            kG: _getColorForCountry('KG'),
            lA: _getColorForCountry('LA'),
            lV: _getColorForCountry('LV'),
            lB: _getColorForCountry('LB'),
            lS: _getColorForCountry('LS'),
            lR: _getColorForCountry('LR'),
            lY: _getColorForCountry('LY'),
            lI: _getColorForCountry('LI'),
            lT: _getColorForCountry('LT'),
            lU: _getColorForCountry('LU'),
            mG: _getColorForCountry('MG'),
            mW: _getColorForCountry('MW'),
            mY: _getColorForCountry('MY'),
            mV: _getColorForCountry('MV'),
            mL: _getColorForCountry('ML'),
            mT: _getColorForCountry('MT'),
            mH: _getColorForCountry('MH'),
            mR: _getColorForCountry('MR'),
            mU: _getColorForCountry('MU'),
            mX: _getColorForCountry('MX'),
            fM: _getColorForCountry('FM'),
            mD: _getColorForCountry('MD'),
            mC: _getColorForCountry('MC'),
            mN: _getColorForCountry('MN'),
            mE: _getColorForCountry('ME'),
            mA: _getColorForCountry('MA'),
            mZ: _getColorForCountry('MZ'),
            mM: _getColorForCountry('MM'),
            nA: _getColorForCountry('NA'),
            nR: _getColorForCountry('NR'),
            nP: _getColorForCountry('NP'),
            nL: _getColorForCountry('NL'),
            nC: _getColorForCountry('NC'),
            nZ: _getColorForCountry('NZ'),
            nI: _getColorForCountry('NI'),
            nG: _getColorForCountry('NG'),
            nU: _getColorForCountry('NU'),
            pK: _getColorForCountry('PK'),
            pW: _getColorForCountry('PW'),
            pA: _getColorForCountry('PA'),
            pG: _getColorForCountry('PG'),
            pY: _getColorForCountry('PY'),
            pE: _getColorForCountry('PE'),
            pL: _getColorForCountry('PL'),
            qA: _getColorForCountry('QA'),
            rO: _getColorForCountry('RO'),
            rU: _getColorForCountry('RU'),
            rW: _getColorForCountry('RW'),
            sH: _getColorForCountry('SH'),
            sT: _getColorForCountry('ST'),
            sA: _getColorForCountry('SA'),
            sN: _getColorForCountry('SN'),
            sC: _getColorForCountry('SC'),
            sL: _getColorForCountry('SL'),
            sG: _getColorForCountry('SG'),
            sK: _getColorForCountry('SK'),
            sI: _getColorForCountry('SI'),
            sB: _getColorForCountry('SB'),
            sO: _getColorForCountry('SO'),
            zA: _getColorForCountry('ZA'),
            sS: _getColorForCountry('SS'),
            sD: _getColorForCountry('SD'),
            eS: _getColorForCountry('ES'),
            lK: _getColorForCountry('LK'),
            sR: _getColorForCountry('SR'),
            sE: _getColorForCountry('SE'),
            cH: _getColorForCountry('CH'),
            sY: _getColorForCountry('SY'),
            tJ: _getColorForCountry('TJ'),
            tO: _getColorForCountry('TO'),
            tT: _getColorForCountry('TT'),
            tN: _getColorForCountry('TN'),
            tR: _getColorForCountry('TR'),
            tM: _getColorForCountry('TM'),
            uG: _getColorForCountry('UG'),
            uA: _getColorForCountry('UA'),
            aE: _getColorForCountry('AE'),
            gB: _getColorForCountry('GB'),
            uS: _getColorForCountry('US'),
            uY: _getColorForCountry('UY'),
            uZ: _getColorForCountry('UZ'),
            vU: _getColorForCountry('VU'),
            vE: _getColorForCountry('VE'),
            vN: _getColorForCountry('VN'),
            yE: _getColorForCountry('YE'),
            zW: _getColorForCountry('ZW'),
            // Continue para todos os países necessários
            // ...
          ).toMap(),
          callback: (id, name, tapdetails) {
            final int userCount = userDistribution[id.toUpperCase()] ?? 0;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(name),
                content: Text('Número de usuários: $userCount'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
