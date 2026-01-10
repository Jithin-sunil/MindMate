import 'package:flutter/material.dart';

class ManagePatients extends StatelessWidget {
  const ManagePatients({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Patient Records", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Adjust based on screen size in real app
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual images
                      ),
                      const SizedBox(height: 10),
                      Text("Patient Name ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Age: ${60 + index} | Stage ${index + 1}", style: TextStyle(color: Colors.grey[600])),
                      const Spacer(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: const [
                              Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                              Text("Track", style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(Icons.medication, color: Colors.teal, size: 20),
                              Text("Meds", style: TextStyle(fontSize: 10)),
                            ],
                          ),
                          Column(
                            children: const [
                              Icon(Icons.history, color: Colors.blue, size: 20),
                              Text("Log", style: TextStyle(fontSize: 10)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}