import 'package:flutter/material.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ModuloCardsCountry extends StatefulWidget {
  const ModuloCardsCountry({super.key});

  @override
  State<ModuloCardsCountry> createState() => _ModuloCardsCountryState();
}

class _ModuloCardsCountryState extends State<ModuloCardsCountry> {
  Map<String, int> userDistribution = {};
  int totalUsers = 0;
  bool isLoading = true;
  String? errorMessage;
  http.Client? _httpClient;

  final Map<String, Color> stateColors = {
    'brAC': Colors.red,
    'brAL': Colors.blue,
    'brAP': Colors.green,
    'brAM': Colors.orange,
    'brBA': Colors.yellow,
    'brCE': Colors.purple,
    'brDF': Colors.brown,
    'brES': Colors.cyan,
    'brGO': Colors.teal,
    'brMA': Colors.indigo,
    'brMT': Colors.lime,
    'brMS': Colors.pink,
    'brMG': Colors.grey,
    'brPA': Colors.blueGrey,
    'brPB': Colors.amber,
    'brPR': Colors.lightGreenAccent,
    'brPE': Colors.deepOrangeAccent,
    'brPI': Colors.lightBlueAccent,
    'brRJ': Colors.deepPurpleAccent,
    'brRN': Colors.pinkAccent,
    'brRS': Colors.cyanAccent,
    'brRO': Colors.yellowAccent,
    'brRR': Colors.tealAccent,
    'brSC': Colors.indigoAccent,
    'brSP': Colors.brown,
    'brSE': Colors.redAccent,
    'brTO': Colors.orangeAccent,
  };

  @override
  void initState() {
    super.initState();
    _httpClient = http.Client();
    _fetchUserData();
  }

  @override
  void dispose() {
    _httpClient?.close(); // Cancela todas as requisições pendentes
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final url = 'https://api.weellu.com/api/v1/admin-panel/users';
      int page = 1;
      const int limit = 3000;
      bool hasMoreData = true;

      while (hasMoreData && mounted) {
        final response = await _httpClient!.get(
          Uri.parse('$url?page=$page&limit=$limit'),
          headers: {
            'admin-key': 'super_password_for_admin',
          },
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data != null && data['data'] != null && data['data']['docs'] != null) {
            final List<dynamic> users = data['data']['docs'];

            if (users.isEmpty) {
              hasMoreData = false;
              continue;
            }

            final Map<String, int> distribution = {};

            for (var user in users) {
              final countryId = user['countryId'];
              final address = user['address'];

              if (countryId != null && countryId['code'] == 'BR' && address != null) {
                String region = address['region']?.toString().toUpperCase() ?? 'Desconhecido';
                if (region.isNotEmpty && region != 'DESCONHECIDO') {
                  String stateKey = 'br$region';
                  distribution[stateKey] = (distribution[stateKey] ?? 0) + 1;
                }
              }
            }

            if (mounted) {
              setState(() {
                userDistribution = _mergeDistributions(userDistribution, distribution);
                totalUsers = userDistribution.values.fold(0, (sum, count) => sum + count);
                isLoading = false;
              });
            }

            page++;
          } else {
            hasMoreData = false;
            if (mounted) {
              setState(() {
                errorMessage = 'Dados da resposta não estão no formato esperado.';
                isLoading = false;
              });
            }
          }
        } else {
          hasMoreData = false;
          if (mounted) {
            setState(() {
              errorMessage = 'Falha ao carregar dados: ${response.statusCode}';
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Erro ao buscar dados: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  Map<String, int> _mergeDistributions(
      Map<String, int> existing, Map<String, int> newDistribution) {
    final merged = Map<String, int>.from(existing);
    newDistribution.forEach((key, value) {
      merged[key] = (merged[key] ?? 0) + value;
    });
    return merged;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (userDistribution.isEmpty) {
      return const Center(child: Text('Nenhum dado disponível'));
    }

    final states = userDistribution.keys.toList();
    final midIndex = (states.length / 2).ceil();
    final firstHalf = states.sublist(0, midIndex);
    final secondHalf = states.sublist(midIndex);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 19, 17, 17),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SimpleMap(
                    instructions: SMapBrazil.instructions,
                    defaultColor: Colors.grey,
                    colors: SMapBrazilColors(
                      brAC: _getMapColors()['brAC'],
                      brAL: _getMapColors()['brAL'],
                      brAM: _getMapColors()['brAM'],
                      brAP: _getMapColors()['brAP'],
                      brBA: _getMapColors()['brBA'],
                      brCE: _getMapColors()['brCE'],
                      brDF: _getMapColors()['brDF'],
                      brES: _getMapColors()['brES'],
                      brGO: _getMapColors()['brGO'],
                      brMA: _getMapColors()['brMA'],
                      brMT: _getMapColors()['brMT'],
                      brMS: _getMapColors()['brMS'],
                      brMG: _getMapColors()['brMG'],
                      brPA: _getMapColors()['brPA'],
                      brPB: _getMapColors()['brPB'],
                      brPR: _getMapColors()['brPR'],
                      brPE: _getMapColors()['brPE'],
                      brPI: _getMapColors()['brPI'],
                      brRJ: _getMapColors()['brRJ'],
                      brRN: _getMapColors()['brRN'],
                      brRS: _getMapColors()['brRS'],
                      brRO: _getMapColors()['brRO'],
                      brRR: _getMapColors()['brRR'],
                      brSC: _getMapColors()['brSC'],
                      brSP: _getMapColors()['brSP'],
                      brSE: _getMapColors()['brSE'],
                      brTO: _getMapColors()['brTO'],
                    ).toMap(),
                    callback: (id, name, tapdetails) {
                      final int userCount = userDistribution[id.toUpperCase()] ?? 0;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(name),
                          content: Text(
                            'Número de usuários: $userCount\nNúmero total de usuários: $totalUsers',
                          ),
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
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 19, 17, 17),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                children: firstHalf.map((region) {
                                  final count = userDistribution[region] ?? 0;
                                  final percentage = (count / totalUsers) * 100;
                                  return _Estados(
                                    cor: _getColorForRegion(region),
                                    texto:
                                        '${region.substring(2)}: $count (${percentage.toStringAsFixed(1)}%)',
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ListView(
                                children: secondHalf.map((region) {
                                  final count = userDistribution[region] ?? 0;
                                  final percentage = (count / totalUsers) * 100;
                                  return _Estados(
                                    cor: _getColorForRegion(region),
                                    texto:
                                        '${region.substring(2)}: $count (${percentage.toStringAsFixed(1)}%)',
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Número Total de Usuários: $totalUsers',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForRegion(String region) {
    return stateColors[region] ?? Colors.white;
  }

  Map<String, Color> _getMapColors() {
    final Map<String, Color> mapColors = {};
    userDistribution.forEach((region, userCount) {
      final opacity = (userCount / totalUsers) * 0.8 + 0.2;
      mapColors[region] = _getColorForRegion(region).withOpacity(opacity.clamp(0.2, 1.0));
    });
    return mapColors;
  }
}

class _Estados extends StatelessWidget {
  final Color cor;
  final String texto;

  const _Estados({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            color: cor,
            margin: const EdgeInsets.only(right: 8),
          ),
          Text(
            texto,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}