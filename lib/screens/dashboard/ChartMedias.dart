import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chartmedias extends StatefulWidget {
  const Chartmedias({super.key});

  @override
  State<Chartmedias> createState() => _ChartmediasState();
}

class _ChartmediasState extends State<Chartmedias> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 12, 12),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        height: 400,
        width: double.infinity,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20, // Defina o valor máximo para o eixo Y
            barGroups: [
              _buildBarGroup(
                0,
                10,
                Colors.blue,
              ), // Textos
              _buildBarGroup(1, 8, Colors.green), // Áudios
              _buildBarGroup(2, 12, Colors.orange), // Arquivos
              _buildBarGroup(3, 7, Colors.red), // Vídeos
              _buildBarGroup(4, 5, Colors.purple), // Localizações
              _buildBarGroup(5, 6, Colors.grey), // Mensagens Apagadas
            ],
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Textos',
                            style: TextStyle(color: Colors.white));
                      case 1:
                        return const Text('Áudios',
                            style: TextStyle(color: Colors.white));
                      case 2:
                        return const Text('Arquivos',
                            style: TextStyle(color: Colors.white));
                      case 3:
                        return const Text('Vídeos',
                            style: TextStyle(color: Colors.white));
                      case 4:
                        return const Text('Localizações',
                            style: TextStyle(color: Colors.white));
                      case 5:
                        return const Text('Apagadas',
                            style: TextStyle(color: Colors.white));
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors
                            .white, // Definindo a cor branca para os números
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 15,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
