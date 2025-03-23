import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddEventScreen extends StatefulWidget {
  final String uid;
  const AddEventScreen({super.key, required this.uid});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String imageUrl = _imageUrlController.text;

      if (imageUrl.isEmpty) {
        throw Exception('Please provide an image URL');
      }

      await FirebaseFirestore.instance.collection('events').add({
        'amount': int.parse(_amountController.text),
        'attendees': ["200"],
        'capacity': int.parse(_capacityController.text),
        'category': _selectedCategory,
        'club_name': _selectedClub,
        'created_by': widget.uid,
        'date': Timestamp.fromDate(_selectedDate),
        'department': _selectedDepartment,
        'description': _descriptionController.text,
        'event_title': _titleController.text,
        'image_url': imageUrl,
        'location': _locationController.text,
        'mode': _selectedMode,
        'status': 'pending',
        'type': _selectedType,
        'updated_at': Timestamp.now(),
      });

      Fluttertoast.showToast(
        msg: "Event created successfully!",
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error creating event: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  String _selectedCategory = 'Tech';
  String _selectedClub = 'Coding Club';
  String _selectedDepartment = 'CSE';
  String _selectedMode = 'Offline';
  String _selectedType = 'Workshop';
  String _selectedStatus = 'pending';

  final List<String> _categories = [
    'Tech',
    'Music',
    'Sports',
    'Art',
    'Business',
  ];
  final List<String> _clubs = ['Coding Club', 'Music Club', 'Drama Club'];
  final List<String> _departments = ['CSE', 'EEE', 'BBA'];
  final List<String> _modes = ['Offline', 'Online'];
  final List<String> _types = ['Workshop', 'Seminar', 'Competition'];
  final List<String> _status = ['pending', 'approved', 'rejected'];

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        items:
            items.map((String item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Event'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Image URL', _imageUrlController),
                      _buildTextField('Event Title', _titleController),
                      _buildTextField(
                        'Description',
                        _descriptionController,
                        maxLines: 3,
                      ),
                      _buildTextField(
                        'Amount',
                        _amountController,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField(
                        'Capacity',
                        _capacityController,
                        keyboardType: TextInputType.number,
                      ),
                      _buildTextField('Location', _locationController),

                      // Dropdowns
                      _buildDropdown(
                        'Category',
                        _categories,
                        _selectedCategory,
                        (val) => setState(() => _selectedCategory = val!),
                      ),
                      _buildDropdown(
                        'Club',
                        _clubs,
                        _selectedClub,
                        (val) => setState(() => _selectedClub = val!),
                      ),
                      _buildDropdown(
                        'Department',
                        _departments,
                        _selectedDepartment,
                        (val) => setState(() => _selectedDepartment = val!),
                      ),
                      _buildDropdown(
                        'Mode',
                        _modes,
                        _selectedMode,
                        (val) => setState(() => _selectedMode = val!),
                      ),
                      _buildDropdown(
                        'Type',
                        _types,
                        _selectedType,
                        (val) => setState(() => _selectedType = val!),
                      ),
                      _buildDropdown(
                        'Status',
                        _status,
                        _selectedStatus,
                        (val) => setState(() => _selectedStatus = val!),
                      ),

                      // Date Picker
                      ListTile(
                        title: Text('Event Date'),
                        subtitle: Text(
                          DateFormat('MMM dd, yyyy').format(_selectedDate),
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2025),
                          );
                          if (date != null) {
                            setState(() => _selectedDate = date);
                          }
                        },
                      ),

                      SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Create Event',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
