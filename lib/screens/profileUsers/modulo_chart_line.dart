import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ModuloChartLine extends StatefulWidget {
  final List<double> values;
  final List<String> labels;
  final String title;
  final Color lineColor;
  
  const ModuloChartLine({
    super.key,
    this.values = const [10, 41, 35, 51, 49, 62, 69, 91, 148], // Valores padrão
    this.labels = const ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set'], // Rótulos padrão
    this.title = 'ESTATÍSTICAS MENSAIS', // Título padrão
    this.lineColor = const Color(0xFF4BA67A), // Cor padrão verde
  });

  @override
  State<ModuloChartLine> createState() => _ModuloChartLineState();
}

class _ModuloChartLineState extends State<ModuloChartLine> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF131111),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com título
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Gráfico de linha
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LineChart(
                    mainData(),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateInterval(widget.values),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < widget.labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.labels[index],
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _calculateInterval(widget.values),
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      minX: 0,
      maxX: widget.values.length.toDouble() - 1,
      minY: 0,
      maxY: _calculateMaxY(widget.values),
      lineBarsData: [
        LineChartBarData(
          spots: widget.values.asMap().entries.map((entry) {
            return FlSpot(entry.key.toDouble(), entry.value);
          }).toList(),
          isCurved: true,
          color: widget.lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                widget.lineColor.withOpacity(0.3),
                widget.lineColor.withOpacity(0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          // tooltipBgColor: Colors.black.withOpacity(0.8),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${widget.labels[spot.x.toInt()]}\n',
                GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: spot.y.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      color: widget.lineColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  double _calculateMaxY(List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2; // 20% a mais que o valor máximo
  }

  double _calculateInterval(List<double> values) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue > 100) return 50;
    if (maxValue > 50) return 20;
    if (maxValue > 20) return 10;
    return 5;
  }
}