import 'package:file_loader/data/datasources/local_csv_datasources.dart';
import 'package:file_loader/data/models/user_model.dart';

class CsvRepository {
  final LocalCsvDataSource _dataSource;

  CsvRepository(this._dataSource);

  Future<List<UserModel>> loadUsersFromCsv() async {
    try {
      return await _dataSource.loadCsvFile();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}

