import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class Chartmedias extends StatefulWidget {
  final List<int> values;
  final List<String> categories;
  final double? height;

  const Chartmedias({
    super.key,
    this.values = const [
      1103505,
      218443,
      152590,
      111074,
      17055,
      13995,
      8827,
      3358
    ],
    this.categories = const [
      'Textos',
      'Informações',
      'Imagens',
      'Áudios',
      'Arquivos',
      'Apagadas',
      'Vídeos',
      'Localização'
    ],
    this.height,
  });

  @override
  State<Chartmedias> createState() => _ChartmediasState();
}

class _ChartmediasState extends State<Chartmedias> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final chartHeight = widget.height ?? mediaQuery.size.height * 0.7;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: chartHeight,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          color: const Color.fromARGB(255, 19, 17, 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTATÍSTICAS DE MÍDIA',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(221, 255, 255, 255),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BarChart(
                  BarChartData(
                    backgroundColor: Color.fromARGB(255, 19, 17, 17),
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: _calculateMaxY(widget.values),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipRoundedRadius: 12,
                        tooltipPadding: const EdgeInsets.all(12),
                        tooltipMargin: 12,
                        fitInsideVertically: true,
                        fitInsideHorizontally: true,
                        tooltipBorder: BorderSide(
                          color: const Color.fromARGB(255, 73, 163, 119)
                              .withOpacity(0.8),
                          width: 1.5,
                        ),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '${widget.categories[groupIndex]}\n',
                            GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    '${_formatFullValue(widget.values[groupIndex])} itens',
                                style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromRGBO(75, 166, 122, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              barTouchResponse == null ||
                              barTouchResponse.spot == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex =
                              barTouchResponse.spot?.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: _calculateInterval(widget.values),
                          getTitlesWidget: (value, meta) {
                            return Text(
                              _formatValue(value.toInt()),
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            );
                          },
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            return Column(
                              children: [
                                Text(
                                  _formatValue(widget.values[index]),
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.categories[index],
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(
                                        255, 126, 126, 126),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                          reservedSize: 50,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _calculateInterval(widget.values),
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    barGroups: List.generate(widget.values.length, (index) {
                      final isTouched = index == touchedIndex;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: widget.values[index].toDouble(),
                            gradient: _createGradient(isTouched
                                ? const Color.fromARGB(255, 79, 159, 122)
                                : const Color.fromARGB(255, 47, 105, 77)),
                            width:
                                80, // Diminuir o valor para reduzir o espaçamento
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatValue(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toString();
  }

  String _formatFullValue(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (Match m) => '.',
        );
  }

  double _calculateMaxY(List<int> values) =>
      (values.reduce((a, b) => a > b ? a : b) * 1.8);

  double _calculateInterval(List<int> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue > 1000000) return 500000;
    if (maxValue > 100000) return 100000;
    if (maxValue > 10000) return 10000;
    return 1000;
  }

  static LinearGradient _createGradient(Color color) => LinearGradient(
        colors: [color.withOpacity(0.8), color, color.withOpacity(0.9)],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
