import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_vehicle_screen.dart';
import '../Theme/theme.dart';
import 'vehicle_details_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';
import '../Providers/vehicle_provider.dart';
import '../Models/vehicle_model.dart';
import '../Providers/auth_provider.dart';

class MyGarageScreen extends ConsumerStatefulWidget {
  const MyGarageScreen({super.key});

  @override
  ConsumerState<MyGarageScreen> createState() => _MyGarageScreenState();
}

class _MyGarageScreenState extends ConsumerState<MyGarageScreen> {
  void _navigateToAddVehicle() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddVehicleScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final vehicleListAsync = ref.watch(vehicleListProvider);
    final theme = Theme.of(context);

    if (user == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pocket Garage',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.translate('welcome')}, ${user.displayName ?? 'Kullanıcı'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppLocalizations.of(context)!.translate('settings'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: theme.cardTheme.color,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: vehicleListAsync.when(
          data: (vehicles) {
            if (vehicles.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return _buildVehicleListCard(vehicles[index]);
              },
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.accent)),
          error: (error, stack) => Center(
            child: Text('Hata: $error',
                style: TextStyle(color: theme.colorScheme.error)),
          ),
        ),
      ),
      floatingActionButton: _buildCustomFab(),
    );
  }

  Widget _buildCustomFab() {
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.3),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _navigateToAddVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('add_first_vehicle'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleListCard(Vehicle vehicle) {
    final String name = vehicle.name.isNotEmpty
        ? vehicle.name
        : AppLocalizations.of(context)!.translate('unnamed_vehicle');
    final String plate = vehicle.plate.isNotEmpty
        ? vehicle.plate
        : AppLocalizations.of(context)!.translate('no_plate');
    final String? imageUrl = vehicle.imageUrl;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VehicleDetailsScreen(
                vehicleId: vehicle.id,
              ),
            ),
          );
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 2.0,
            ),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? Icon(Icons.directions_car, color: theme.iconTheme.color)
              : null,
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            plate,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.iconTheme.color,
          size: 28,
        ),
      ),
    );
  }
}
