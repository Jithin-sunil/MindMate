import 'package:flutter/material.dart';
import 'package:mindmate_patient/manage_persons.dart';
import 'package:mindmate_patient/profile.dart'; // Ensure this path is correct for your patient app

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background like Caregiver App
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Hello, John", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)), // Placeholder Name
            Text("My MindMate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientProfileScreen()),
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

      // --- BOTTOM NAVIGATION (Optional for Patient, but good for consistency) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Meds"),
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),

      // --- MAIN BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. MY STATUS CARD (Replaces 'Patient Status Card')
            _buildMyStatusCard(),
            const SizedBox(height: 25),

            // 2. SOS BUTTON (Critical for Patient)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sending Emergency SOS..."), backgroundColor: Colors.red),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                icon: const Icon(Icons.sos, color: Colors.white, size: 28),
                label: const Text("EMERGENCY HELP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 25),

            // 3. QUICK ACTIONS GRID
            const Text("My Activities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildQuickActionsGrid(),
            const SizedBox(height: 25),

            // 4. RECENT REMINDERS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Up Next", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.teal))),
              ],
            ),
            _buildRecentReminders(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET: MY STATUS CARD ---
  Widget _buildMyStatusCard() {
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
                  const Text("Current Status:", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const Text("I am Safe", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      const Text("Home", style: TextStyle(color: Colors.white, fontSize: 12)),
                      const SizedBox(width: 15),
                      const Icon(Icons.battery_std, color: Colors.white, size: 14),
                      const Text(" 85%", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ],
          ),
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
        
        // --- NEW BUTTON: KNOWN PERSONS ---
        _buildActionBtn("Family & Friends", Icons.people_alt_rounded, Colors.purple, () {
           Navigator.push(
             context, 
             MaterialPageRoute(builder: (context) => const ManageKnownPeopleScreen())
           );
        }),
        // ---------------------------------

        _buildActionBtn("Meds", Icons.medication_outlined, Colors.pink, () {}),
        _buildActionBtn("Reminders", Icons.alarm, Colors.teal, () {}),
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

  // --- WIDGET: RECENT REMINDERS LIST ---
  Widget _buildRecentReminders() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
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
              backgroundColor: index == 0 ? Colors.blue.shade50 : Colors.orange.shade50,
              child: Icon(
                index == 0 ? Icons.medication : Icons.directions_walk,
                color: index == 0 ? Colors.blue : Colors.orange,
              ),
            ),
            title: Text(index == 0 ? "Take Medicine" : "Evening Walk", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text(index == 0 ? "Donepezil - After Lunch" : "15 mins around the park", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            trailing: Text(index == 0 ? "1:00 PM" : "5:30 PM", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ),
        );
      },
    );
  }
}