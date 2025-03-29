import 'package:flutter/material.dart';
import 'package:diu_evento/screens/login_screen.dart';
import 'package:diu_evento/screens/admin/events/add_event_screen.dart';
import 'package:diu_evento/screens/admin/events/events_list_screen.dart';

class AdminDrawer extends StatelessWidget {
  final String uid;
  const AdminDrawer({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[200]!, Colors.purple[100]!],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      'assets/images/admin_avatar.png',
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'john@email.com',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 20),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.event,
                      title: 'Events',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsListScreen(uid: uid),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.event_note_outlined,
                      title: 'Add Event',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEventScreen(uid: uid),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.rate_review_outlined,
                      title: 'Reviews',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.payment_outlined,
                      title: 'Payments',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      onTap: () {},
                    ),
                    Divider(height: 32, thickness: 1),

                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Logout'),
                                content: Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      // Close drawer and dialog
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // Navigate to login screen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
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

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(icon, size: 26, color: Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      horizontalTitleGap: 20,
    );
  }
}
