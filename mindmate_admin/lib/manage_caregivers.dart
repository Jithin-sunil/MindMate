import 'package:flutter/material.dart';

class ManageCaregivers extends StatefulWidget {
  const ManageCaregivers({super.key});

  @override
  State<ManageCaregivers> createState() => _ManageCaregiversState();
}

class _ManageCaregiversState extends State<ManageCaregivers> {
  // State to toggle between List View and Add Form
  bool _isAddingNew = false;

  // Dummy Data
  final List<Map<String, String>> _caregivers = List.generate(
    5,
    (index) => {
      'id': 'CG00${index + 1}',
      'name': 'Caregiver User ${index + 1}',
      'email': 'caregiver${index + 1}@gmail.com',
      'contact': '+91 987654321$index',
      'address': '123 Street, City $index',
      'status': 'Active',
    },
  );

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. HEADER (Dynamic Buttons) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAddingNew ? "Add New Caregiver" : "Caregiver List",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  _isAddingNew 
                    ? "Fill in the details below to register a new caregiver." 
                    : "Manage authorized caregivers and their access.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            
            // Toggle Button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isAddingNew = !_isAddingNew; // Toggle View
                });
              },
              icon: Icon(_isAddingNew ? Icons.arrow_back : Icons.add),
              label: Text(_isAddingNew ? "Back to List" : "Add Caregiver"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAddingNew ? Colors.grey[800] : Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // --- 2. CONTENT AREA (Switch between Table and Form) ---
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: _isAddingNew ? _buildAddForm() : _buildTable(),
          ),
        ),
      ],
    );
  }

  // ==============================================================================
  // WIDGET: DATA TABLE
  // ==============================================================================
  Widget _buildTable() {
    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
        dataRowHeight: 60,
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Contact')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _caregivers.map((caregiver) {
          return DataRow(cells: [
            DataCell(Text(caregiver['id']!)),
            DataCell(const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person, size: 20),
            )),
            DataCell(Text(caregiver['name']!, style: const TextStyle(fontWeight: FontWeight.w500))),
            DataCell(Text(caregiver['email']!)),
            DataCell(Text(caregiver['contact']!)),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      _caregivers.remove(caregiver);
                    });
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  // ==============================================================================
  // WIDGET: ADD FORM (Embedded)
  // ==============================================================================
  Widget _buildAddForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHOTO UPLOAD SECTION ---
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 16,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        onPressed: () {
                          // Handle Photo Pick
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- INPUT FIELDS GRID (2 Columns) ---
            Row(
              children: [
                Expanded(child: _buildTextField(_nameController, "Full Name", Icons.person)),
                const SizedBox(width: 20),
                Expanded(child: _buildTextField(_emailController, "Email Address", Icons.email)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextField(_contactController, "Phone Number", Icons.phone)),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    validator: (val) => val!.length < 6 ? "Min 6 chars" : null,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(_addressController, "Residential Address", Icons.location_on, maxLines: 3),
            
            const SizedBox(height: 30),

            // --- ACTION BUTTONS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Clear fields and go back
                    _clearForm();
                    setState(() => _isAddingNew = false);
                  },
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _saveCaregiver,
                  icon: const Icon(Icons.check),
                  label: const Text("Save Caregiver"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER METHODS ---

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (val) => val == null || val.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  void _saveCaregiver() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _caregivers.add({
          'id': 'CG00${_caregivers.length + 1}',
          'name': _nameController.text,
          'email': _emailController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          'status': 'Active',
        });
        _isAddingNew = false; // Switch back to table view
      });
      _clearForm();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Caregiver Saved Successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _contactController.clear();
    _addressController.clear();
    _passwordController.clear();
    _isPasswordVisible = false;
  }
}