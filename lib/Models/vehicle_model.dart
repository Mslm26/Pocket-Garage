import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String userId;
  final String name;
  final String plate;
  final int year;
  final String? imageUrl;
  final DateTime? inspectionDate;
  final DateTime? insuranceDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vehicle({
    required this.id,
    required this.userId,
    required this.name,
    required this.plate,
    required this.year,
    this.imageUrl,
    this.inspectionDate,
    this.insuranceDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Vehicle(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      plate: data['plate'] ?? '',
      year: data['year']?.toInt() ?? 0,
      imageUrl: data['imageUrl'],
      inspectionDate: (data['inspectionDate'] as Timestamp?)?.toDate(),
      insuranceDate: (data['insuranceDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'plate': plate,
      'year': year,
      'imageUrl': imageUrl,
      'inspectionDate':
          inspectionDate != null ? Timestamp.fromDate(inspectionDate!) : null,
      'insuranceDate':
          insuranceDate != null ? Timestamp.fromDate(insuranceDate!) : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
