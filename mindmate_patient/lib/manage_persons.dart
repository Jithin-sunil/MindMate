import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart'; // Import AudioPlayers
import 'package:mindmate_patient/add_knownperson.dart';
import 'package:mindmate_patient/main.dart';

class ManageKnownPeopleScreen extends StatefulWidget {
  const ManageKnownPeopleScreen({super.key});

  @override
  State<ManageKnownPeopleScreen> createState() => _ManageKnownPeopleScreenState();
}

class _ManageKnownPeopleScreenState extends State<ManageKnownPeopleScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio Player Instance
  bool _isPlaying = false;

  // --- 1. FETCH DATA ---
  Future<List<Map<String, dynamic>>> _fetchKnownPeople() async {
    final patientId = supabase.auth.currentUser!.id;
    final response = await supabase
        .from('tbl_knownperson')
        .select('*, tbl_patient(patient_name)')
        .eq('patient_id', patientId)
        .order('knownperson_name', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  // --- 2. DELETE PERSON ---
  Future<void> _deletePerson(int id) async {
    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Person?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await supabase.from('tbl_knownperson').delete().eq('knownperson_id', id);
      setState(() {}); // Refresh List
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Person deleted.")));
    }
  }

  // --- 3. IDENTIFY PERSON (FACE RECOGNITION MOCK) ---
  Future<void> _identifyPerson() async {
    // A. Pick Image (Camera or Gallery)
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Scan Face (Camera)'), onTap: () => Navigator.pop(ctx, ImageSource.camera)),
            ListTile(leading: const Icon(Icons.photo), title: const Text('Upload Photo (Gallery)'), onTap: () => Navigator.pop(ctx, ImageSource.gallery)),
          ],
        ),
      ),
    );

    if (source == null) return;

    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    // B. Show "Scanning" Loading Indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Colors.teal)),
    );

    // C. SIMULATE FACIAL RECOGNITION (Real implementation requires ML Kit)
    await Future.delayed(const Duration(seconds: 2)); // Fake processing time
    
    // For this demo, we will just fetch the FIRST person in the list to simulate a "Match".
    // In a real app, you would send 'image.path' to a Python backend or use Google ML Kit to compare embeddings.
    final patientId = supabase.auth.currentUser!.id;
    final data = await supabase.from('tbl_knownperson').select().eq('patient_id', patientId).limit(1).maybeSingle();

    if (mounted) Navigator.pop(context); // Close loading

    if (data != null) {
      // D. Show Result & Play Audio
      _showMatchResult(data);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No match found in your records.")));
    }
  }

  // --- 4. SHOW RESULT & PLAY AUDIO ---
  void _showMatchResult(Map<String, dynamic> person) {
    // Auto-play audio if available
    if (person['knownperson_voice_message'] != null) {
      _playAudio(person['knownperson_voice_message']);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 400,
          child: Column(
            children: [
              const Text("Match Found! ✅", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: person['knownperson_photo'] != null ? NetworkImage(person['knownperson_photo']) : null,
                child: person['knownperson_photo'] == null ? const Icon(Icons.person, size: 60) : null,
              ),
              const SizedBox(height: 20),
              Text("This is ${person['knownperson_name']}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text("Relation: ${person['knownperson_relation']}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 30),
              
              // Audio Controls
              if (person['knownperson_voice_message'] != null)
                ElevatedButton.icon(
                  onPressed: () => _playAudio(person['knownperson_voice_message']),
                  icon: const Icon(Icons.volume_up),
                  label: const Text("Replay Voice Message"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                )
              else
                const Text("No voice message recorded.", style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _audioPlayer.stop(); // Stop audio when closing popup
    });
  }

  Future<void> _playAudio(String url) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint("Audio Error: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Family & Friends"),
        backgroundColor: Colors.teal,
        actions: [
          // IDENTIFY BUTTON IN APP BAR
          IconButton(
            icon: const Icon(Icons.face_retouching_natural),
            tooltip: "Identify Person",
            onPressed: _identifyPerson,
          )
        ],
      ),
      
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchKnownPeople(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No known people added yet."));
          }

          final people = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: person['knownperson_photo'] != null 
                        ? NetworkImage(person['knownperson_photo']) 
                        : null,
                    child: person['knownperson_photo'] == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text(person['knownperson_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(person['knownperson_relation']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Voice Indicator
                      if (person['knownperson_voice_message'] != null)
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.blue),
                          onPressed: () => _playAudio(person['knownperson_voice_message']),
                        ),
                      // DELETE BUTTON
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePerson(person['knownperson_id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddKnownPersonScreen()));
          setState(() {}); // Refresh on return
        },
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Person", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}