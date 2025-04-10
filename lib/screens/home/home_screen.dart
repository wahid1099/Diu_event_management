import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diu_evento/screens/events/event_details_screen.dart';
import 'package:diu_evento/screens/profile/profile_screen.dart';
import 'package:diu_evento/screens/events/all_events_screen.dart';
import 'package:diu_evento/screens/bookings/my_bookings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Fix the _onItemTapped method
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllEventsScreen(uid: widget.uid),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyBookingsScreen(uid: widget.uid),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(uid: widget.uid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with user info and location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/admin_avatar.png',
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi Welcome 👋',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.uid)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final userData =
                                    snapshot.data!.data()
                                        as Map<String, dynamic>?;
                                return Text(
                                  userData?['name'] ?? 'User',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                              return Text('Loading...');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      Text('Dhaka, 1202'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Find amazing events',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.filter_list),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Popular Events Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Events 🔥',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AllEventsScreen(uid: widget.uid),
                        ),
                      );
                    },
                    child: Text('VIEW ALL'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Popular Events Cards
              // Update the ListView.builder to ensure proper horizontal scrolling
              SizedBox(
                height: 280,
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('events')
                          .where('status', isEqualTo: 'approved')
                          .orderBy('updated_at', descending: true)
                          .limit(10)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print('Firestore Error: ${snapshot.error}');
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      print('No events found or empty data');
                      return const Center(
                        child: Text(
                          'No events available',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    // final events = snapshot.data!.docs;
                    // print('Found ${events.length} events'); // Debug print

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final event =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        final eventId = snapshot.data!.docs[index].id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EventDetailsScreen(
                                      eventId: eventId,
                                      event: event,
                                      uid: widget.uid,
                                    ),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              width: 280,
                              margin: EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      event['image_url'] ?? '',
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event['event_title'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              event['date']
                                                      ?.toDate()
                                                      .toString()
                                                      .split(' ')[0] ??
                                                  '',
                                            ),
                                            SizedBox(width: 16),
                                            Icon(Icons.location_on, size: 16),
                                            SizedBox(width: 4),
                                            Text(event['location'] ?? ''),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 24),

              // Categories Section
              Text(
                'Choose By Category ✨',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryItem(
                      Icons.design_services,
                      'Design',
                      Colors.orange,
                    ),
                    _buildCategoryItem(Icons.art_track, 'Art', Colors.blue),
                    _buildCategoryItem(
                      Icons.sports_soccer,
                      'Sports',
                      Colors.green,
                    ),
                    _buildCategoryItem(
                      Icons.music_note,
                      'Music',
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
