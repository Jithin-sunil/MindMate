import 'package:flutter/material.dart';
import 'package:mindmate_caregiver/profile.dart';

class CaregiverHomeScreen extends StatefulWidget {
  const CaregiverHomeScreen({super.key});

  @override
  State<CaregiverHomeScreen> createState() => _CaregiverHomeScreenState();
}

class _CaregiverHomeScreenState extends State<CaregiverHomeScreen> {
  int _currentIndex = 0;

  // Function to handle navigation logic
  void _onTabTapped(int index) {
    if (index == 3) {
      // 2. IF SETTINGS TAB (Index 3) IS TAPPED -> GO TO PROFILE
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CaregiverProfileScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Hello, Caregiver", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            Text("MindMate+", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          
          // 3. PROFILE ICON NAVIGATION
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CaregiverProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      
      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // Use the custom function
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Patients"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

      // --- MAIN BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PATIENT STATUS CARD
            _buildPatientStatusCard(),
            const SizedBox(height: 25),

            // 2. QUICK ACTIONS GRID
            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildQuickActionsGrid(),
            const SizedBox(height: 25),

            // 3. RECENT ALERTS LIST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.teal))),
              ],
            ),
            _buildRecentAlerts(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: PATIENT STATUS CARD ---
  Widget _buildPatientStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with Patient Photo
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Monitoring:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Text("Grandpa John", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                        child: const Text("SAFE", style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.battery_std, color: Colors.white, size: 16),
                      const Text(" 85%", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Last Location Update:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text("2 mins ago", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET: QUICK ACTIONS GRID ---
  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildActionBtn("Track Map", Icons.map_outlined, Colors.blue, () {}),
        _buildActionBtn("Safe Zones", Icons.security, Colors.orange, () {}),
        _buildActionBtn("Meds", Icons.medication_outlined, Colors.pink, () {}),
        _buildActionBtn("Reminders", Icons.alarm, Colors.purple, () {}),
        _buildActionBtn("Gallery", Icons.photo_library_outlined, Colors.indigo, () {}),
        _buildActionBtn("Emergency", Icons.sos, Colors.red, () {}),
      ],
    );
  }

  Widget _buildActionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: RECENT ALERTS LIST ---
  Widget _buildRecentAlerts() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: index == 0 ? Colors.red.shade50 : Colors.blue.shade50,
              child: Icon(
                index == 0 ? Icons.warning_amber_rounded : Icons.info_outline,
                color: index == 0 ? Colors.red : Colors.blue,
              ),
            ),
            title: Text(index == 0 ? "Left Safe Zone" : "Medicine Reminder", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(index == 0 ? "Patient moved out of 'Home' zone" : "Donepezil 5mg due", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            trailing: Text("${index + 1}h ago", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ),
        );
      },
    );
  }
}