import 'package:flutter/material.dart';
import 'package:mindmate_caregiver/patient.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mindmate_caregiver/main.dart'; // Import supabase client


class ManagePatientsScreen extends StatefulWidget {
  const ManagePatientsScreen({super.key});

  @override
  State<ManagePatientsScreen> createState() => _ManagePatientsScreenState();
}

class _ManagePatientsScreenState extends State<ManagePatientsScreen> {
  
@override
initState() {
    super.initState();
    _fetchPatients();
  }

  // --- FETCH PATIENTS FUNCTION ---
  Future<List<Map<String, dynamic>>> _fetchPatients() async {
    final userId = supabase.auth.currentUser!.id;
    // print("userId: $userId");
    
    final response = await supabase
        .from('tbl_patient')
        .select()
        .eq('caregiver_id', userId)
        .order('patient_name', ascending: true); // Alphabetical order
      // print(response);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("My Patients", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button on tab view
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPatients(),
        builder: (context, snapshot) {
          // 1. LOADING STATE
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          // 2. ERROR STATE
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 3. EMPTY STATE (No Patients)
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text("No Patients Added Yet", style: TextStyle(color: Colors.grey, fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddPatient(context),
                    icon: const Icon(Icons.add),
                    label: const Text("Add New Patient"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            );
          }

          // 4. DATA LIST STATE
          final patients = snapshot.data!;
          
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Triggers rebuild to re-fetch data
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                final String? photoUrl = patient['patient_photo'];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.teal.shade50,
                      backgroundImage: photoUrl != null 
                          ? NetworkImage(photoUrl) 
                          : null,
                      child: photoUrl == null 
                          ? const Icon(Icons.person, color: Colors.teal) 
                          : null,
                    ),
                    title: Text(
                      patient['patient_name'] ?? "Unknown",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Age: ${patient['patient_age']} | ${patient['patient_gender']}"),
                        Text(
                          "Condition: ${patient['patient_medical_condition']}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      // TODO: Navigate to Patient Detail Screen
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => PatientDetailScreen(patientId: patient['patient_id'])));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      
      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPatient(context),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToAddPatient(BuildContext context) async {
    // Wait for the result from AddPatientScreen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPatientScreen()),
    );
    // Refresh the list after coming back (in case a new patient was added)
    if (mounted) {
      setState(() {});
    }
  }
}