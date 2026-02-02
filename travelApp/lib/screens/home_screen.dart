import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      bottomNavigationBar: _bottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 24),
              _upcomingTripCard(),
              const SizedBox(height: 24),
              _quickInfoRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Good Evening, Traveler', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Monday, Feb 2, 2026 | 2:11 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        const CircleAvatar(
          backgroundColor: Color(0xFF1E2749),
          child: Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _upcomingTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFF3A4F7A), Color(0xFF5E3B76)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Upcoming Trip', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          const Text('Sunrise Hike – Grand Canyon', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Tomorrow, Feb 3', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: const [
              Icon(Icons.alarm, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Alarm set for 4:45 AM', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickInfoRow() {
    return Row(
      children: [
        _infoTile(Icons.directions_bus, 'Shuttle', '3:00 AM'),
        const SizedBox(width: 12),
        _infoTile(Icons.hotel, 'Checkout', '11:00 AM'),
        const SizedBox(width: 12),
        _infoTile(Icons.cloud, 'Weather', '35°F'),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFF1A2040), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0B1020),
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Journal'),
        BottomNavigationBarItem(icon: CircleAvatar(radius: 18, backgroundColor: Colors.deepPurpleAccent, child: Icon(Icons.add, color: Colors.white)), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}