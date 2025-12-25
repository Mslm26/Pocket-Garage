import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../Models/vehicle_model.dart';

class VehicleRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  VehicleRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Stream<List<Vehicle>> getVehicles(String userId) {
    return _firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final vehicles =
          snapshot.docs.map((doc) => Vehicle.fromFirestore(doc)).toList();
      vehicles.sort((a, b) {
        final aTime = a.createdAt;
        final bTime = b.createdAt;
        if (aTime == null || bTime == null) return 0;
        return bTime.compareTo(aTime);
      });
      return vehicles;
    });
  }

  Stream<Vehicle> getVehicleStream(String vehicleId) {
    return _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .snapshots()
        .map((doc) => Vehicle.fromFirestore(doc));
  }

  Future<Vehicle> getVehicle(String vehicleId) async {
    final doc = await _firestore.collection('vehicles').doc(vehicleId).get();
    if (!doc.exists) throw Exception("Vehicle not found");
    return Vehicle.fromFirestore(doc);
  }

  Future<String> addVehicle(Vehicle vehicle, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      final ref = _storage
          .ref()
          .child('vehicle_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final data = vehicle.toMap();
    if (imageUrl != null) data['imageUrl'] = imageUrl;

    final docRef = await _firestore.collection('vehicles').add(data);
    return docRef.id;
  }

  Future<void> updateVehicle(Vehicle vehicle, File? imageFile) async {
    String? imageUrl = vehicle.imageUrl;
    if (imageFile != null) {
      final ref = _storage
          .ref()
          .child('vehicle_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    final data = vehicle.toMap();
    data['imageUrl'] = imageUrl;
    data.remove('createdAt');

    await _firestore.collection('vehicles').doc(vehicle.id).update(data);
  }

  Future<void> deleteVehicle(String vehicleId, String? imageUrl) async {
    if (imageUrl != null) {
      try {
        await _storage.refFromURL(imageUrl).delete();
      } catch (e) {}
    }

    final expenses = await _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('expenses')
        .get();

    for (var doc in expenses.docs) {
      await doc.reference.delete();
    }

    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }
}
