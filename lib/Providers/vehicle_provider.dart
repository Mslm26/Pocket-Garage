import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Repositories/vehicle_repository.dart';
import '../Models/vehicle_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository();
});

final vehicleListProvider = StreamProvider<List<Vehicle>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicles(user.uid);
});

final vehicleDetailsProvider =
    StreamProvider.family<Vehicle, String>((ref, vehicleId) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return repository.getVehicleStream(vehicleId);
});
