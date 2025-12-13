extension StringExtensions on String {
  String get trimAndLower => trim().toLowerCase();
  
  bool get isNullOrEmpty => isEmpty;
  
  bool get isNotNullOrEmpty => !isEmpty;
}

