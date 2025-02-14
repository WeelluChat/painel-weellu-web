import 'package:flutter/material.dart';

class ModuloChartLine extends StatefulWidget {
  const ModuloChartLine({super.key});

  @override
  State<ModuloChartLine> createState() => _ModuloChartLineState();
}

class _ModuloChartLineState extends State<ModuloChartLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      // color: Colors.amber,
      child: Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff292929),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
