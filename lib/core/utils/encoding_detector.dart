import 'dart:io';
import 'dart:convert';

/// Utility class for detecting and handling file encodings
/// 
/// This class provides methods to:
/// - Detect the encoding of a file
/// - Read files with automatic encoding detection
/// - Handle common CSV encodings (UTF-8, Windows-1251, ISO-8859-1, etc.)
class EncodingDetector {
  /// Common encodings to try when reading CSV files
  /// Ordered by likelihood of occurrence
  static const List<String> commonEncodings = [
    'utf-8',           // Most common, especially for modern files
    'windows-1251',    // Common for Cyrillic/Russian text
    'iso-8859-1',      // Latin-1, common in Western Europe
    'windows-1252',    // Windows Latin-1 variant
    'iso-8859-15',     // Latin-9, Western European
    'cp866',           // DOS Cyrillic
    'koi8-r',          // Russian KOI8-R
    'utf-16',          // UTF-16 LE/BE (less common for CSV)
  ];

  /// Attempts to detect the encoding of a file by trying common encodings
  /// 
  /// Returns the encoding name if successful, or null if none work
  /// 
  /// [file] - The file to analyze
  /// [sampleSize] - Number of bytes to sample (default: 8192)
  static Future<String?> detectEncoding(File file, {int sampleSize = 8192}) async {
    final bytes = await file.openRead(0, sampleSize).toList();
    final sample = bytes.expand((chunk) => chunk).toList();
    
    // Try each encoding
    for (final encodingName in commonEncodings) {
      try {
        final encoding = _getEncoding(encodingName);
        if (encoding != null) {
          encoding.decode(sample);
          return encodingName;
        }
      } catch (e) {
        // This encoding doesn't work, try next
        continue;
      }
    }
    
    return null;
  }

  /// Reads a file with automatic encoding detection
  /// 
  /// Tries UTF-8 first, then falls back to other common encodings.
  /// As a last resort, uses Latin1 which can decode any byte sequence
  /// (though characters may not display correctly).
  /// 
  /// [file] - The file to read
  /// [preferredEncoding] - Preferred encoding to try first (default: 'utf-8')
  /// 
  /// Returns a tuple of (content, detectedEncoding)
  /// Throws an exception if no valid encoding is found
  static Future<({String content, String encoding})> readFileWithEncoding(
    File file, {
    String? preferredEncoding,
  }) async {
    final bytes = await file.readAsBytes();
    
    // Check for UTF-16 BOM first
    if (hasUtf16Bom(bytes)) {
      throw Exception(
        'UTF-16 encoding detected. Please convert the file to UTF-8 before loading. '
        'You can do this by opening the file in a text editor and saving it as UTF-8.'
      );
    }
    
    // List of encodings to try, with preferred first
    final encodingsToTry = preferredEncoding != null
        ? [preferredEncoding, ...commonEncodings.where((e) => e != preferredEncoding && e != 'utf-16')]
        : commonEncodings.where((e) => e != 'utf-16').toList();

    Exception? lastException;
    
    // Try each encoding
    for (final encodingName in encodingsToTry) {
      try {
        final encoding = _getEncoding(encodingName);
        if (encoding != null) {
          final content = encoding.decode(bytes);
          // Validate that the decoding was successful by checking for replacement characters
          // If we see too many replacement characters, the encoding is probably wrong
          if (!content.contains('\uFFFD') || encodingName == 'utf-8') {
            return (content: content, encoding: encodingName);
          }
        }
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        continue;
      }
    }
    
    // Last resort: try Latin1 (can decode any byte sequence)
    // This will work but may produce incorrect characters
    try {
      final content = latin1.decode(bytes);
      return (content: content, encoding: 'iso-8859-1');
    } catch (e) {
      // Even Latin1 failed, which shouldn't happen, but handle it
      throw Exception(
        'Failed to decode file with any supported encoding. '
        'The file may be corrupted or in an unsupported format. '
        'Last error: ${lastException?.toString() ?? e.toString()}'
      );
    }
  }

  /// Gets the Encoding object for a given encoding name
  static Encoding? _getEncoding(String encodingName) {
    switch (encodingName.toLowerCase()) {
      case 'utf-8':
        return utf8;
      case 'windows-1251':
        return _getWindows1251Encoding();
      case 'iso-8859-1':
        return latin1;
      case 'windows-1252':
        return _getWindows1252Encoding();
      case 'iso-8859-15':
        return _getIso8859_15Encoding();
      case 'cp866':
        return _getCp866Encoding();
      case 'koi8-r':
        return _getKoi8REncoding();
      case 'utf-16':
        // UTF-16 is not directly supported in dart:convert
        // Files with UTF-16 BOM should be converted to UTF-8 externally
        return null;
      default:
        return null;
    }
  }

  /// Windows-1251 encoding (Cyrillic)
  /// Returns null if encoding is not available on this platform
  static Encoding? _getWindows1251Encoding() {
    final encoding = Encoding.getByName('windows-1251');
    return encoding; // Will be null if not available
  }

  /// Windows-1252 encoding (Western European)
  /// Returns null if encoding is not available on this platform
  static Encoding? _getWindows1252Encoding() {
    final encoding = Encoding.getByName('windows-1252');
    return encoding; // Will be null if not available
  }

  /// ISO-8859-15 encoding
  /// Returns null if encoding is not available on this platform
  static Encoding? _getIso8859_15Encoding() {
    final encoding = Encoding.getByName('iso-8859-15');
    return encoding; // Will be null if not available
  }

  /// CP866 encoding (DOS Cyrillic)
  /// Returns null if encoding is not available on this platform
  static Encoding? _getCp866Encoding() {
    final encoding = Encoding.getByName('cp866');
    return encoding; // Will be null if not available
  }

  /// KOI8-R encoding (Russian)
  /// Returns null if encoding is not available on this platform
  static Encoding? _getKoi8REncoding() {
    final encoding = Encoding.getByName('koi8-r');
    return encoding; // Will be null if not available
  }

  /// Checks if a byte sequence is valid UTF-8
  static bool isValidUtf8(List<int> bytes) {
    try {
      utf8.decode(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Detects UTF-16 BOM
  /// Returns true if UTF-16 BOM is detected
  static bool hasUtf16Bom(List<int> bytes) {
    if (bytes.length < 2) return false;
    
    // UTF-16 LE BOM: FF FE
    if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      return true;
    }
    
    // UTF-16 BE BOM: FE FF
    if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      return true;
    }
    
    return false;
  }
}

