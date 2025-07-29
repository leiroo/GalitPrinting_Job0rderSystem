import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'sidebar.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalSales = AppData.payments.where((p) => p.status == 'Completed').fold<double>(0, (sum, p) => sum + p.amount);
    final totalProfit = totalSales * 0.25; // Example: 25% margin
    final salesByService = <String, double>{};
    for (final order in AppData.orders) {
      salesByService[order.service] = (salesByService[order.service] ?? 0) + order.price;
    }
    final salesByCustomer = <String, double>{};
    for (final order in AppData.orders) {
      salesByCustomer[order.customer] = (salesByCustomer[order.customer] ?? 0) + order.price;
    }
    return Scaffold(
      appBar: AppBar(
        leading: isMobile
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: const Text('Reports'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ProfileMenu(),
          ),
        ],
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      drawer: isMobile ? const Drawer(child: Sidebar()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const Sidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 6 : 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Reports Dashboard', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 28,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87),
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Comprehensive business reports and financial insights for informed decision making',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _reportCard('Total Sales', '₱${totalSales.toStringAsFixed(2)}', Icons.attach_money, Colors.blue, context),
                      const SizedBox(width: 24),
                      _reportCard('Total Profit', '₱${totalProfit.toStringAsFixed(2)}', Icons.trending_up, Colors.green, context),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Sales by Service Section
                  Text(
                    'Sales by Service', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenue breakdown by service type to identify your most profitable offerings',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 380,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.grey[600]! : Color(0xFFE5E7EB)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: isMobile ? 1000 : 900,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: (salesByService.values.isNotEmpty ? 
                              (salesByService.values.reduce((a, b) => a > b ? a : b) * 1.1).ceilToDouble() : 12000),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.black87,
                                tooltipRoundedRadius: 8,
                                tooltipPadding: const EdgeInsets.all(8),
                                tooltipMargin: 8,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final keys = salesByService.keys.toList();
                                  final service = keys[group.x.toInt()];
                                  final value = rod.toY;
                                  
                                  return BarTooltipItem(
                                    '$service\n₱${value.toStringAsFixed(0)}',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '\n${(value / 1000).toStringAsFixed(1)}K',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true, 
                                  reservedSize: 40,
                                  interval: (salesByService.values.isNotEmpty ? 
                                    (salesByService.values.reduce((a, b) => a > b ? a : b) * 1.1 / 6).ceilToDouble() : 2000),
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${(value / 1000).toInt()}K',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? Colors.grey[300] : Colors.black87,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final keys = salesByService.keys.toList();
                                    if (value.toInt() >= 0 && value.toInt() < keys.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          keys[value.toInt()],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark ? Colors.grey[300] : Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                  interval: 1,
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: (salesByService.values.isNotEmpty ? 
                                (salesByService.values.reduce((a, b) => a > b ? a : b) * 1.1 / 6).ceilToDouble() : 2000),
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(show: true),
                            barGroups: [
                              for (int i = 0; i < salesByService.length; i++)
                                BarChartGroupData(
                                  x: i,
                                  barRods: [
                                    BarChartRodData(
                                      toY: salesByService.values.elementAt(i),
                                      color: Colors.blueAccent,
                                      width: 24,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Sales by Customer Section
                  Text(
                    'Sales by Customer', 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black87)
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customer revenue distribution to understand your top clients and market segments',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: isMobile ? 500 : 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.grey[600]! : Color(0xFFE5E7EB)),
                    ),
                    child: isMobile 
                      ? Column(
                          children: [
                            // Pie Chart on top for mobile
                            Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: 300,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        for (int i = 0; i < salesByCustomer.length; i++)
                                          PieChartSectionData(
                                            color: Colors.primaries[i % Colors.primaries.length].shade300,
                                            value: salesByCustomer.values.elementAt(i),
                                            title: '',
                                            radius: 80,
                                            titleStyle: const TextStyle(fontSize: 0),
                                          ),
                                      ],
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 30,
                                      pieTouchData: PieTouchData(
                                        enabled: true,
                                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                          // Handle touch events if needed
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Legend at bottom for mobile
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer Sales',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87, // Fixed: Dynamic color based on theme
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...salesByCustomer.entries.map((entry) {
                                      final index = salesByCustomer.keys.toList().indexOf(entry.key);
                                      final color = Colors.primaries[index % Colors.primaries.length].shade300;
                                      final percentage = (entry.value / salesByCustomer.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1);
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    entry.key,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '₱${entry.value.toStringAsFixed(0)} ($percentage%)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            // Pie Chart on the left for desktop
                            Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width: 320,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        for (int i = 0; i < salesByCustomer.length; i++)
                                          PieChartSectionData(
                                            color: Colors.primaries[i % Colors.primaries.length].shade300,
                                            value: salesByCustomer.values.elementAt(i),
                                            title: '',
                                            radius: 90,
                                            titleStyle: const TextStyle(fontSize: 0),
                                          ),
                                      ],
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 35,
                                      pieTouchData: PieTouchData(
                                        enabled: true,
                                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                          // Handle touch events if needed
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Legend on the right for desktop
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Customer Sales',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87, // Fixed: Dynamic color based on theme
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...salesByCustomer.entries.map((entry) {
                                      final index = salesByCustomer.keys.toList().indexOf(entry.key);
                                      final color = Colors.primaries[index % Colors.primaries.length].shade300;
                                      final percentage = (entry.value / salesByCustomer.values.reduce((a, b) => a + b) * 100).toStringAsFixed(1);
                                      
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    entry.key,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    '₱${entry.value.toStringAsFixed(0)} ($percentage%)',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Sales by Service Table Section
                  const Text('Sales by Service (Table)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 8),
                  const Text(
                    'Detailed service revenue data in tabular format for easy reference and analysis',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...salesByService.entries.map((e) => ListTile(
                    leading: const Icon(Icons.local_offer, color: Colors.indigo),
                    title: Text(e.key),
                    trailing: Text('₱${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                  const SizedBox(height: 32),
                  
                  // Sales by Customer Table Section
                  const Text('Sales by Customer (Table)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 8),
                  const Text(
                    'Customer revenue data in tabular format for detailed client analysis and reporting',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...salesByCustomer.entries.map((e) => ListTile(
                    leading: const Icon(Icons.person, color: Colors.deepPurple),
                    title: Text(e.key),
                    trailing: Text('₱${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _reportCard(String title, String value, IconData icon, Color color, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  
  return Expanded(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : const Color(0xFFE5E7EB),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: color)),
            ],
          ),
        ),
      ),
    ),
  );
}