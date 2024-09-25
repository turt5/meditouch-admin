import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class RevenueChart extends StatelessWidget {
  final Map<String, double> revenueData;

  RevenueChart({required this.revenueData});

  @override
  Widget build(BuildContext context) {
    // Get today's date and the first date of the month
    DateTime now = DateTime.now();
    // DateTime startOfMonth = DateTime(now.year, now.month, 1);

    final List<SalesData> chartData = List.generate(
      now.day,
      (index) {
        DateTime date = DateTime(now.year, now.month, index + 1);
        double amount = revenueData[DateFormat('yyyy-MM-dd').format(date)] ??
            0; // Use 0 if no data
        return SalesData(date, amount);
      },
    );

    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return ClipRRect(
          child: Column(
            children: [
              Text('Daily Revenue for Current Month',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface)),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SfCartesianChart(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
                    margin: EdgeInsets.all(35),
                    legend: const Legend(isVisible: true),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      lineType: TrackballLineType.vertical,
                      tooltipSettings: const InteractiveTooltip(
                        enable: true,
                        format: 'point.x: point.y',
                      ),
                    ),
                    enableAxisAnimation: true,
                    primaryXAxis: const CategoryAxis(
                      majorGridLines: MajorGridLines(width: 1), // Hide vertical gridlines
                      labelRotation: 45, // Rotate labels for better readability
                      interval: 10, // Show each day
                    ),
                    // title: ChartTitle(
                    //     text: 'Daily Revenue for Current Month',
                    //     textStyle: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: Theme.of(context).colorScheme.onSurface),
                    // ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      canShowMarker: true,
                    ),

                    series: [
                      AreaSeries<SalesData, String>(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3), // Area color with opacity
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => DateFormat('yyyy-MM-dd')
                            .format(sales.date), // Format date for x-axis
                        yValueMapper: (SalesData sales, _) => sales.amount,
                      ),
                      LineSeries<SalesData, String>(
                        color: Theme.of(context).colorScheme.primary,
                        dataSource: chartData,
                        xValueMapper: (SalesData sales, _) => DateFormat('yyyy-MM-dd')
                            .format(sales.date), // Format date for x-axis
                        yValueMapper: (SalesData sales, _) => sales.amount,
                        width: 5, // Line width
                        enableTooltip: true,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          color: Theme.of(context).colorScheme.secondary,
                          shape: DataMarkerType.circle,
                        ),
                        emptyPointSettings: EmptyPointSettings(
                          mode:
                              EmptyPointMode.gap, // Skips the 0 values, preventing markers
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class SalesData {
  final DateTime date; // Keep as DateTime type
  final double amount;

  SalesData(this.date, this.amount);
}
