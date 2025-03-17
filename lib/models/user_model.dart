class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? address;
  final String? department;
  final String? name;
  final String? phone;
  final String? semester;
  final String? studentId;

  UserModel({
    required this.uid,
    required this.email,
    this.role = 'user',
    this.address,
    this.department,
    this.name,
    this.phone,
    this.semester,
    this.studentId,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      role: data['role'] ?? 'user',
      address: data['address'],
      department: data['department'],
      name: data['name'],
      phone: data['phone'],
      semester: data['semester'],
      studentId: data['student_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'address': address,
      'department': department,
      'name': name,
      'phone': phone,
      'semester': semester,
      'student_id': studentId,
    };
  }
}
