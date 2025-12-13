import 'package:flutter/material.dart';
import 'package:file_loader/core/constants/app_constants.dart';
import 'package:file_loader/features/users/presentation/controllers/user_controller.dart';
import 'package:file_loader/features/users/presentation/widgets/filter_bar.dart';
import 'package:file_loader/features/users/presentation/widgets/user_cart.dart';
import 'package:file_loader/shared/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _showFilters = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV User Filter'),
        actions: [
          Consumer<UserController>(
            builder: (context, controller, _) {
              if (controller.hasUsers) {
                return IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                  tooltip: 'Toggle Filters',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<UserController>(
        builder: (context, controller, _) {
          // Loading State
          if (controller.isLoading) {
            return LoadingIndicator(message: AppConstants.processingCsv);
          }

          // Error State
          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.loadingError,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: controller.loadCsvFile,
                      icon: const Icon(Icons.refresh),
                      label: const Text(AppConstants.loadCsv),
                    ),
                  ],
                ),
              ),
            );
          }

          // No CSV Loaded State
          if (!controller.hasUsers) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.noCsvLoaded,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.noCsvLoadedMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: controller.loadCsvFile,
                      icon: const Icon(Icons.upload_file),
                      label: const Text(AppConstants.loadCsv),
                    ),
                  ],
                ),
              ),
            );
          }

          // Has Users - Show List
          final filteredUsers = controller.filteredUsers;
          
          return Column(
            children: [
              // Filter Bar (if enabled)
              if (_showFilters) const FilterBar(),
              
              // Results Count
              if (controller.filter.hasActiveFilters)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Text(
                    'Showing ${filteredUsers.length} of ${controller.allUsers.length} users',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              
              // User List
              Expanded(
                child: filteredUsers.isEmpty
                    ? _buildEmptyState(context, theme)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return UserCard(user: filteredUsers[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<UserController>(
        builder: (context, controller, _) {
          if (!controller.isLoading && !controller.hasUsers) {
            return FloatingActionButton.extended(
              onPressed: controller.loadCsvFile,
              icon: const Icon(Icons.upload_file),
              label: const Text(AppConstants.loadCsv),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.noResults,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.noResultsMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

