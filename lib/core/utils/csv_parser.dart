import 'package:csv/csv.dart';
import 'package:file_loader/data/models/user_model.dart';

class CsvParser {
  static List<UserModel> parseCsv(String csvContent) {
    try {
      final List<List<dynamic>> rowsAsListOfValues = 
          const CsvToListConverter().convert(csvContent);

      if (rowsAsListOfValues.isEmpty) {
        return [];
      }

      // First row is header
      final List<String> headers = rowsAsListOfValues[0]
          .map((e) => e.toString().trim())
          .toList()
          .cast<String>();

      // Skip header row and parse data rows
      final List<UserModel> users = [];
      
      for (int i = 1; i < rowsAsListOfValues.length; i++) {
        final row = rowsAsListOfValues[i];
        final Map<String, String> userMap = {};
        
        for (int j = 0; j < headers.length && j < row.length; j++) {
          userMap[headers[j]] = row[j].toString().trim();
        }
        
        try {
          users.add(UserModel.fromMap(userMap));
        } catch (e) {
          // Skip invalid rows
          continue;
        }
      }
      
      return users;
    } catch (e) {
      throw Exception('Failed to parse CSV: $e');
    }
  }
}

