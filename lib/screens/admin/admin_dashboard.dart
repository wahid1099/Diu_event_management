import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildStatsCard('Total Events', '156', Icons.event),
                _buildStatsCard('Active Users', '2,453', Icons.people),
                _buildStatsCard('Revenue', '\$15,240', Icons.attach_money),
              ],
            ),
            const SizedBox(height: 24.0),

            // Charts Section
            Container(
              height: 300,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(2.6, 2),
                        const FlSpot(4.9, 5),
                        const FlSpot(6.8, 3.1),
                        const FlSpot(8, 4),
                        const FlSpot(9.5, 3),
                        const FlSpot(11, 4),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Recent Activities
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Activities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildActivityItem(
                      'New Event Created',
                      'Tech Conference 2024',
                      '2 hours ago',
                    ),
                    _buildActivityItem(
                      'User Registration',
                      'John Doe joined',
                      '5 hours ago',
                    ),
                    _buildActivityItem(
                      'Event Updated',
                      'Workshop location changed',
                      '1 day ago',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(time, style: const TextStyle(color: Colors.grey)),
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
    );
  }
}
