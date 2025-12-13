import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_loader/core/utils/csv_parser.dart';
import 'package:file_loader/data/models/user_model.dart';

class LocalCsvDataSource {
  Future<List<UserModel>> loadCsvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvContent = await file.readAsString();
        return CsvParser.parseCsv(csvContent);
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      throw Exception('Error loading CSV file: $e');
    }
  }
}

