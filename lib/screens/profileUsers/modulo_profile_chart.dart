import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuloProfileChart extends StatefulWidget {
  final List<int> values;
  final List<String> categories;
  final double? height;

  const ModuloProfileChart({
    super.key,
    this.values = const [
      1103505, 218443, 152590, 111074, 17055, 13995, 8827, 3358
    ],
    this.categories = const [
      'Textos', 'Infos', 'Imagens', 'Áudios',
      'Arquivos', 'Apagadas', 'Vídeos', 'Locais'
    ],
    this.height,
  });

  @override
  State<ModuloProfileChart> createState() => _ModuloProfileChartState();
}

class _ModuloProfileChartState extends State<ModuloProfileChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final chartHeight = widget.height ?? mediaQuery.size.height * 0.7;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: chartHeight,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF131111),
            // border: Border.all(
            //   color: Colors.grey.withOpacity(0.2),
            //   width: 1,
            // ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESTATÍSTICAS DE MÍDIA',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    backgroundColor: Colors.transparent,
                    alignment: BarChartAlignment.spaceEvenly,
                    groupsSpace: 12,
                    maxY: _calculateMaxY(widget.values),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        // tooltipBgColor: Colors.black.withOpacity(0.8),
                        tooltipRoundedRadius: 12,
                        tooltipPadding: const EdgeInsets.all(12),
                        tooltipMargin: 8,
                        fitInsideVertically: true,
                        fitInsideHorizontally: true,
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
                                text: '${_formatFullValue(widget.values[groupIndex])} itens',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF4BA67A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
                          touchedIndex = barTouchResponse.spot?.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: _calculateInterval(widget.values),
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(
                                _formatValue(value.toInt()),
                                style: GoogleFonts.poppins(
                                  color: Colors.grey.withOpacity(0.7),
                                  fontSize: 11,
                                ),
                              ),
                            );
                          },
                          reservedSize: 42,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < widget.categories.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      _formatValue(widget.values[index]),
                                      style: GoogleFonts.poppins(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.categories[index],
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.withOpacity(0.7),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
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
                          color: Colors.grey.withOpacity(0.15),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    barGroups: widget.values.asMap().entries.map((entry) {
                      final index = entry.key;
                      final value = entry.value;
                      final isTouched = index == touchedIndex;
                      
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value.toDouble(),
                            color: isTouched 
                                ? const Color(0xFF4BA67A).withOpacity(0.9)
                                : const Color(0xFF4BA67A).withOpacity(0.6),
                            width: 60,
                            borderRadius: BorderRadius.circular(4),
                            // backDrawRodData: BackgroundBarChartRodData(
                            //   show: true,
                            //   toY: _calculateMaxY(widget.values),
                            //   color: Colors.grey.withOpacity(0.1),
                            // ),
                          ),
                        ],
                      );
                    }).toList(),
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

  double _calculateMaxY(List<int> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.8;
  }

  double _calculateInterval(List<int> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue > 1000000) return 500000;
    if (maxValue > 100000) return 100000;
    if (maxValue > 10000) return 10000;
    return 1000;
  }
}