import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildChartCard(
              context,
              title: 'Books by Category',
              child: SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: [
                        ChartData('Novel', 35),
                        ChartData('Epik', 15),
                        ChartData('Puisi', 20),
                        ChartData('Sejarah', 10),
                        ChartData('Agama', 25),
                        ChartData('Sains', 5),
                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.count,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildChartCard(
              context,
              title: 'Monthly Borrowings',
              child: SizedBox(
                height: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    LineSeries<ChartData, String>(
                      dataSource: [
                        ChartData('Jan', 120),
                        ChartData('Feb', 150),
                        ChartData('Mar', 180),
                        ChartData('Apr', 210),
                        ChartData('May', 190),
                        ChartData('Jun', 220),
                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.count,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildChartCard(
              context,
              title: 'User Distribution',
              child: SizedBox(
                height: 300,
                child: SfCircularChart(
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      dataSource: [
                        ChartData('Readers', 85),
                        ChartData('Clerks', 10),
                        ChartData('Managers', 5),
                      ],
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.count,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, {required String title, required Widget child}) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final int count;

  ChartData(this.category, this.count);
}