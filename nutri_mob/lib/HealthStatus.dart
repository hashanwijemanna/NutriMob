import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthStatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Status'),
        backgroundColor: Color(0xFF00B2A9),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFE0F8F7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Current Health Status'),
              SizedBox(height: 16),
              _buildHealthMetrics(),
              SizedBox(height: 16),
              Container(
                height: 250,
                child: _buildChartSection(),
              ),
              SizedBox(height: 16),
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade800,
        fontFamily: 'Lexend',
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMetricRow('BMI:', '24.5', Colors.blueAccent),
            SizedBox(height: 8),
            _buildMetricRow('Weight:', '72 kg', Colors.green),
            SizedBox(height: 8),
            _buildMetricRow('Height:', '175 cm', Colors.orange),
            SizedBox(height: 8),
            _buildMetricRow('Calories Consumed:', '1500 kcal', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Lexend',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toString(),
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 10),
              FlSpot(1, 15),
              FlSpot(2, 20),
              FlSpot(3, 10),
              FlSpot(4, 25),
            ],
            isCurved: true,
            color: Colors.blueAccent,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Health Tips'),
            SizedBox(height: 8),
            Text(
              '• Stay hydrated by drinking plenty of water.\n'
                  '• Follow a balanced diet with fruits and vegetables.\n'
                  '• Exercise regularly to maintain a healthy weight.\n'
                  '• Get enough sleep and manage stress effectively.\n'
                  '• Avoid smoking and excessive alcohol consumption.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
