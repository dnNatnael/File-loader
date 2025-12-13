import 'package:flutter/material.dart';
import 'package:file_loader/core/theme/app_theme.dart';
import 'package:file_loader/data/datasources/local_csv_datasources.dart';
import 'package:file_loader/data/repositories/csv_repository.dart';
import 'package:file_loader/features/users/presentation/controllers/user_controller.dart';
import 'package:file_loader/features/users/presentation/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final csvDataSource = LocalCsvDataSource();
    final csvRepository = CsvRepository(csvDataSource);
    final userController = UserController(csvRepository);

    return ChangeNotifierProvider.value(
      value: userController,
      child: MaterialApp(
        title: 'CSV User Filter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const UserListScreen(),
      ),
    );
  }
}

