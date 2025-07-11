import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hack_motion_test/data/swing_data.dart';
import 'package:hack_motion_test/models/swing_capture.dart';

class InspectionPage extends StatefulWidget {
  final List<SwingCapture> swings; // Loaded swings
  final int initialIndex; // Index of the the first selected swing

  const InspectionPage(
      {super.key,
      required this.swings,
      required this.initialIndex,
      });
  @override
  _InspectionPageState createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  late List<SwingCapture> swings; // Local copy of the swings list
  late int idx; // Current swing index

  @override
  void initState() {
    super.initState();
    swings = List.from(widget.swings);
    idx = widget.initialIndex;
  }

  void _prev() {
    if (idx > 0) setState(() => idx--);
  }

  void _next() {
    if (idx < swings.length - 1) setState(() => idx++);
  }

  // Deletes the current swing file and updates both local and global state
  void _delete() async {
  final swing = swings[idx];
  await context.read<SwingData>().deleteSwing(swing);
  swings.removeAt(idx);

  // If no swings left return to HomePage with true
  if (swings.isEmpty) {
    Navigator.pop(context, true);
    return;
  }

  if (idx >= swings.length) idx = swings.length - 1;
  setState(() {});
}

  @override
  Widget build(BuildContext context) {
    final current = swings[idx];
    final flexEx = current.parameters['HFA_crWrFlexEx'] ?? []; // Flex/Ext data
    final radUln = current.parameters['HFA_crWrRadUln'] ?? []; // Radial/Ulnar data
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection'),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: Icon(Icons.delete), onPressed: _delete)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(current.name, style: Theme.of(context).textTheme.titleMedium),
            Text('Swing graph', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: Colors.blue, label: 'Flex/Ext'),
                SizedBox(width: 16),
                _LegendDot(color: Colors.orange, label: 'Rad/Uln'),
              ],
            ),
            SizedBox(height: 8),
            // Graph showing both data sets using flCharts dependency
            Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                height: 200,
                child: LineChart(
                  LineChartData(
                    minY: -50,
                    maxY: 50,
                    backgroundColor: Colors.white,
                    lineTouchData: LineTouchData(enabled: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        if (value == 0) {
                          // Solid center line
                          return FlLine(
                            color: Colors.grey.shade500,
                            strokeWidth: 1.5,
                            dashArray: null,
                          );
                        } else {
                          // Dotted lines
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                            dashArray: [3, 3],
                          );
                        }
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 32,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    // The two graph lines using current swings values
                    lineBarsData: [
                      LineChartBarData(
                        spots: flexEx
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: Colors.blueAccent,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: radUln
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                )),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: idx > 0 ? _prev : null, child: Text('Previous')),
                TextButton(
                    onPressed: idx < swings.length - 1 ? _next : null,
                    child: Text('Next')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}