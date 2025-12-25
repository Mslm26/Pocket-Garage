import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../Theme/theme.dart';
import 'dart:io';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';
import '../Utils/snackbar_utils.dart';
import '../Utils/notification_service.dart';
import '../l10n/app_localizations.dart';
import '../Providers/vehicle_provider.dart';
import '../Models/vehicle_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  final Vehicle? vehicle;

  const AddVehicleScreen({
    super.key,
    this.vehicle,
  });

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late final TextEditingController _plateController;
  File? _selectedImage;
  String? _existingImageUrl;
  DateTime? _inspectionDate;
  DateTime? _insuranceDate;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final vehicle = widget.vehicle;
    _nameController = TextEditingController(text: vehicle?.name);
    _yearController = TextEditingController(text: vehicle?.year.toString());
    _plateController = TextEditingController(text: vehicle?.plate);
    _existingImageUrl = vehicle?.imageUrl;
    _inspectionDate = vehicle?.inspectionDate;
    _insuranceDate = vehicle?.insuranceDate;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermissions();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  final _pagePadding = const EdgeInsets.symmetric(horizontal: 16.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle != null
            ? AppLocalizations.of(context)!.translate('edit_vehicle')
            : AppLocalizations.of(context)!.translate('add_new_vehicle')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: _pagePadding,
        children: [
          const SizedBox(height: 24),
          _buildImageUploader(context),
          _buildSectionHeader(
              AppLocalizations.of(context)!.translate('vehicle_name_label')),
          CustomTextField(
            controller: _nameController,
            hintText:
                AppLocalizations.of(context)!.translate('vehicle_name_hint'),
            textCapitalization: TextCapitalization.words,
            maxLength: 30,
          ),
          _buildSectionHeader(
              AppLocalizations.of(context)!.translate('model_year_label')),
          CustomTextField(
            controller: _yearController,
            hintText:
                AppLocalizations.of(context)!.translate('model_year_hint'),
            keyboardType: TextInputType.number,
            maxLength: 4,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          _buildSectionHeader(
              AppLocalizations.of(context)!.translate('plate_number_label')),
          CustomTextField(
            controller: _plateController,
            hintText:
                AppLocalizations.of(context)!.translate('plate_number_hint'),
            textCapitalization: TextCapitalization.characters,
            maxLength: 15,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s-]')),
            ],
          ),
          const SizedBox(height: 24),
          _buildDatePickerField(
            label: _inspectionDate == null
                ? AppLocalizations.of(context)!
                    .translate('inspection_date_label')
                : DateFormat('dd MMMM yyyy',
                        AppLocalizations.of(context)!.locale.toString())
                    .format(_inspectionDate!),
            icon: Icons.calendar_today_outlined,
            isSelected: _inspectionDate != null,
            onTap: () async {
              final pickedDate = await _pickDate(context);
              if (pickedDate != null) {
                setState(() {
                  _inspectionDate = pickedDate;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          _buildDatePickerField(
            label: _insuranceDate == null
                ? AppLocalizations.of(context)!
                    .translate('insurance_date_label')
                : DateFormat('dd MMMM yyyy',
                        AppLocalizations.of(context)!.locale.toString())
                    .format(_insuranceDate!),
            icon: Icons.calendar_today_outlined,
            isSelected: _insuranceDate != null,
            onTap: () async {
              final pickedDate = await _pickDate(context);
              if (pickedDate != null) {
                setState(() {
                  _insuranceDate = pickedDate;
                });
              }
            },
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: _buildBottomSaveButton(),
    );
  }

  Future<void> _saveVehicle() async {
    if (_nameController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _plateController.text.isEmpty) {
      SnackBarUtils.showError(context,
          AppLocalizations.of(context)!.translate('fill_required_fields'));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Kullanıcı girişi yapılmamış!");

      int? year = int.tryParse(_yearController.text);
      if (year == null || year < 1900 || year > DateTime.now().year + 1) {
        if (mounted) {
          SnackBarUtils.showError(
              context, AppLocalizations.of(context)!.translate('invalid_year'));
        }
        setState(() => _isLoading = false);
        return;
      }

      final plateInput = _plateController.text.trim().toUpperCase();
      final plateRegex = RegExp(r'^[A-Z0-9\s-]{2,15}$');

      if (!plateRegex.hasMatch(plateInput)) {
        if (mounted) {
          SnackBarUtils.showError(context,
              AppLocalizations.of(context)!.translate('invalid_plate'));
        }
        setState(() => _isLoading = false);
        return;
      }

      String effectiveVehicleId;

      if (widget.vehicle != null) {
        final updatedVehicle = Vehicle(
          id: widget.vehicle!.id,
          userId: user.uid,
          name: _nameController.text.trim(),
          plate: plateInput,
          year: year,
          imageUrl: _existingImageUrl,
          inspectionDate: _inspectionDate,
          insuranceDate: _insuranceDate,
          createdAt: widget.vehicle!.createdAt,
          updatedAt: DateTime.now(),
        );

        await ref
            .read(vehicleRepositoryProvider)
            .updateVehicle(updatedVehicle, _selectedImage);
        effectiveVehicleId = widget.vehicle!.id;

        if (mounted) {
          SnackBarUtils.showSuccess(
            context,
            AppLocalizations.of(context)!.translate('vehicle_updated'),
          );
        }
      } else {
        final newVehicle = Vehicle(
          id: '',
          userId: user.uid,
          name: _nameController.text.trim(),
          plate: plateInput,
          year: year,
          imageUrl: null,
          inspectionDate: _inspectionDate,
          insuranceDate: _insuranceDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        effectiveVehicleId = await ref
            .read(vehicleRepositoryProvider)
            .addVehicle(newVehicle, _selectedImage);

        if (mounted) {
          SnackBarUtils.showSuccess(
            context,
            AppLocalizations.of(context)!.translate('vehicle_added'),
          );
        }
      }

      if (_inspectionDate != null) {
        final scheduledDate = DateTime(_inspectionDate!.year,
            _inspectionDate!.month, _inspectionDate!.day, 9, 0, 0);

        final title = AppLocalizations.of(context)!
            .translate('notification_inspection_title');
        final body = AppLocalizations.of(context)!
            .translate('notification_inspection_body')
            .replaceAll('{plate}', _plateController.text);

        await NotificationService().scheduleNotification(
          id: effectiveVehicleId.hashCode,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
        );
      }

      if (_insuranceDate != null) {
        final scheduledDate = DateTime(_insuranceDate!.year,
            _insuranceDate!.month, _insuranceDate!.day, 9, 0, 0);

        final title = AppLocalizations.of(context)!
            .translate('notification_insurance_title');
        final body = AppLocalizations.of(context)!
            .translate('notification_insurance_body')
            .replaceAll('{plate}', _plateController.text);

        await NotificationService().scheduleNotification(
          id: effectiveVehicleId.hashCode + 1,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hata: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library,
                  color: Theme.of(context).iconTheme.color),
              title: Text(
                  AppLocalizations.of(context)!.translate('pick_from_gallery'),
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera,
                  color: Theme.of(context).iconTheme.color),
              title: Text(AppLocalizations.of(context)!.translate('take_photo'),
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.accent,
                  onPrimary: AppColors.background,
                  onSurface: AppColors.primaryText,
                ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.cardBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildImageUploader(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: DottedBorder(
        color: theme.dividerColor,
        strokeWidth: 2,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.cardTheme.color?.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                )
              : _existingImageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        _existingImageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: theme.textTheme.bodyMedium?.color,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('tap_to_add_image'),
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final Color? labelColor = isSelected
        ? theme.textTheme.bodyLarge?.color
        : theme.textTheme.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: labelColor, fontSize: 16),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: theme.iconTheme.color),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSaveButton() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: CustomButton(
        text: widget.vehicle != null
            ? AppLocalizations.of(context)!.translate('save_changes')
            : AppLocalizations.of(context)!.translate('save_vehicle'),
        onPressed: _saveVehicle,
        isLoading: _isLoading,
      ),
    );
  }
}
