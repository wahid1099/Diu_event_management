import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 50),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/admin_avatar.png'),
            ),
            SizedBox(height: 10),
            Text(
              'Admin Name',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'admin@diu.edu.bd',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 20),
            Divider(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.group,
                    title: 'Manage Clubs',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.event,
                    title: 'Create Event',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_today,
                    title: 'All Events',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Manage Events',
                    onTap: () {},
                  ),
                  Divider(),
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  Divider(),
                  _buildDrawerItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {},
                  ),
                ],
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
    return InkWell(
      onTap: onTap,
      onHover: (hovering) {},
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700], size: 26),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        dense: true,
        horizontalTitleGap: 12,
      ),
    );
  }
}
