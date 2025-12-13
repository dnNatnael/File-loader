import 'package:flutter/material.dart';
import 'package:file_loader/core/constants/app_constants.dart';
import 'package:file_loader/features/users/domain/user_filter.dart';
import 'package:file_loader/features/users/presentation/controllers/user_controller.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late TextEditingController _countryController;
  late TextEditingController _followersController;
  String _selectedSex = AppConstants.sexAll;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _countryController = TextEditingController();
    _followersController = TextEditingController();
  }

  void _initializeFromFilter(UserFilter filter) {
    if (!_initialized) {
      _countryController.text = filter.country ?? '';
      _selectedSex = filter.sex ?? AppConstants.sexAll;
      _followersController.text = filter.minFollowers?.toString() ?? '';
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    _followersController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final controller = context.read<UserController>();
    final minFollowers = int.tryParse(_followersController.text) ?? 0;
    
    final newFilter = UserFilter(
      country: _countryController.text.trim().isEmpty 
          ? null 
          : _countryController.text.trim(),
      sex: _selectedSex == AppConstants.sexAll ? null : _selectedSex,
      minFollowers: minFollowers > 0 ? minFollowers : null,
    );
    
    controller.updateFilter(newFilter);
  }

  void _clearFilters() {
    _countryController.clear();
    _followersController.clear();
    _selectedSex = AppConstants.sexAll;
    context.read<UserController>().clearFilter();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<UserController>(
      builder: (context, controller, _) {
        // Initialize filter values from controller
        _initializeFromFilter(controller.filter);
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Country Filter
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: AppConstants.filterCountry,
                    hintText: AppConstants.countryPlaceholder,
                    prefixIcon: const Icon(Icons.public),
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
                const SizedBox(height: 12),
                
                // Sex Filter
                DropdownButtonFormField<String>(
                  value: _selectedSex,
                  decoration: InputDecoration(
                    labelText: AppConstants.filterSex,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  items: [
                    AppConstants.sexAll,
                    AppConstants.sexMale,
                    AppConstants.sexFemale,
                  ].map((sex) {
                    return DropdownMenuItem(
                      value: sex,
                      child: Text(sex),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSex = value;
                      });
                      _applyFilters();
                    }
                  },
                ),
                const SizedBox(height: 12),
                
                // Min Followers Filter
                TextField(
                  controller: _followersController,
                  decoration: InputDecoration(
                    labelText: AppConstants.filterMinFollowers,
                    hintText: AppConstants.followersPlaceholder,
                    prefixIcon: const Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _applyFilters(),
                ),
                const SizedBox(height: 16),
                
                // Clear Filters Button
                OutlinedButton(
                  onPressed: _clearFilters,
                  child: const Text(AppConstants.clearFilters),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

