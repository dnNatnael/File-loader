import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:file_loader/core/utils/csv_parser.dart';
import 'package:file_loader/core/utils/encoding_detector.dart';
import 'package:file_loader/data/models/user_model.dart';

class LocalCsvDataSource {
  /// Loads a CSV file with automatic encoding detection
  /// 
  /// This method attempts to read the file using multiple encodings:
  /// 1. UTF-8 (default and most common)
  /// 2. Windows-1251 (Cyrillic/Russian)
  /// 3. ISO-8859-1 (Latin-1)
  /// 4. Other common encodings
  /// 
  /// Throws an exception if the file cannot be decoded with any supported encoding
  Future<List<UserModel>> loadCsvFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        // Use encoding detector to read file with automatic encoding detection
        final encodingResult = await EncodingDetector.readFileWithEncoding(file);
        final csvContent = encodingResult.content;
        final detectedEncoding = encodingResult.encoding;
        
        // Log detected encoding for debugging (optional)
        print('CSV file loaded with encoding: $detectedEncoding');
        
        return CsvParser.parseCsv(csvContent);
      } else {
        throw Exception('No file selected');
      }
    } catch (e) {
      // Provide more detailed error message
      if (e.toString().contains('decode') || e.toString().contains('encoding')) {
        throw Exception(
          'Error loading CSV file: Failed to decode file. '
          'The file may be encoded in an unsupported format. '
          'Please ensure the file is saved as UTF-8 or a supported encoding. '
          'Original error: $e'
        );
      }
      throw Exception('Error loading CSV file: $e');
    }
  }
}

