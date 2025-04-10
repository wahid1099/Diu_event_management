// Add these imports at the top
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;
  final String uid; // Make sure this exists

  const EditEventScreen({
    super.key,
    required this.eventId,
    required this.eventData,
    required this.uid,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _capacityController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late String _selectedCategory;
  late String _selectedClub;
  late String _selectedDepartment;
  late String _selectedMode;
  late String _selectedType;

  // Add to the existing state variables
  late TextEditingController _imageUrlController;

  // Add to state variables
  late String _selectedStatus;

  // Add to initState
  @override
  void initState() {
    super.initState();
    // Add this with other initializations
    _selectedStatus = widget.eventData['status']?.toString() ?? _statuses[0];
    // Add this with other controller initializations
    _imageUrlController = TextEditingController(
      text: widget.eventData['image_url']?.toString() ?? '',
    );
    // Initialize controllers with existing data with null safety
    _titleController = TextEditingController(
      text: widget.eventData['event_title']?.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.eventData['description']?.toString() ?? '',
    );
    _amountController = TextEditingController(
      text: widget.eventData['amount']?.toString() ?? '0',
    );
    _capacityController = TextEditingController(
      text: widget.eventData['capacity']?.toString() ?? '0',
    );
    _locationController = TextEditingController(
      text: widget.eventData['location']?.toString() ?? '',
    );
    _selectedDate =
        (widget.eventData['date'] as Timestamp?)?.toDate() ?? DateTime.now();
    _selectedCategory =
        widget.eventData['category']?.toString() ?? _categories[0];
    _selectedClub = widget.eventData['club_name']?.toString() ?? _clubs[0];
    _selectedDepartment =
        widget.eventData['department']?.toString() ?? _departments[0];
    _selectedMode = widget.eventData['mode']?.toString() ?? _modes[0];
    _selectedType = widget.eventData['type']?.toString() ?? _types[0];
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .update({
            'amount': int.parse(_amountController.text),
            'capacity': int.parse(_capacityController.text),
            'category': _selectedCategory,
            'club_name': _selectedClub,
            'date': Timestamp.fromDate(_selectedDate),
            'department': _selectedDepartment,
            'description': _descriptionController.text,
            'event_title': _titleController.text,
            'location': _locationController.text,
            'mode': _selectedMode,
            'type': _selectedType,
            'updated_at': Timestamp.now(),
            'image_url': _imageUrlController.text,
            'status': _selectedStatus,
          });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Event updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Add these lists for dropdowns
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
            items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Add status options list with other lists
  final List<String> _statuses = ['pending', 'approved', 'rejected'];

  // In the build method, add the status dropdown before the save button
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        elevation: 0,
        backgroundColor: Colors.purple[200],
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
                      // Add this at the top of the form
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            _imageUrlController.text.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Center(child: Icon(Icons.error)),
                                  ),
                                )
                                : Center(child: Icon(Icons.image)),
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        'Image URL',
                        _imageUrlController,
                        keyboardType: TextInputType.url,
                      ),
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
                      // Date Picker
                      ListTile(
                        title: Text('Event Date'),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                        ),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      _buildDropdown(
                        'Category',
                        _categories,
                        _selectedCategory,
                        (value) => setState(() => _selectedCategory = value!),
                      ),
                      _buildDropdown(
                        'Club',
                        _clubs,
                        _selectedClub,
                        (value) => setState(() => _selectedClub = value!),
                      ),
                      _buildDropdown(
                        'Department',
                        _departments,
                        _selectedDepartment,
                        (value) => setState(() => _selectedDepartment = value!),
                      ),
                      _buildDropdown(
                        'Mode',
                        _modes,
                        _selectedMode,
                        (value) => setState(() => _selectedMode = value!),
                      ),
                      _buildDropdown(
                        'Type',
                        _types,
                        _selectedType,
                        (value) => setState(() => _selectedType = value!),
                      ),
                      // Add status dropdown here
                      _buildDropdown(
                        'Status',
                        _statuses,
                        _selectedStatus,
                        (value) => setState(() => _selectedStatus = value!),
                      ),
                    ],
                  ),
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateEvent,
        backgroundColor: Colors.purple[200],
        child: Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _imageUrlController.dispose(); // Add this
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _capacityController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
