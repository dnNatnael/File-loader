# 📁 File Loader - CSV User Filter App

A modern Flutter application for loading, parsing, and filtering user data from CSV files. Built with clean architecture principles, this app provides an intuitive interface for managing and exploring user datasets with advanced filtering capabilities.

## ✨ Features

### 🔍 **Smart CSV Loading**
- **Automatic Encoding Detection**: Intelligently detects and handles multiple file encodings (UTF-8, Windows-1251, ISO-8859-1, Windows-1252, and more)
- **Robust Error Handling**: Clear error messages with actionable solutions
- **File Picker Integration**: Easy file selection using native file picker

### 🎯 **Advanced Filtering**
- **Country Filter**: Search users by country name (case-insensitive, partial match)
- **Gender Filter**: Filter by Male, Female, or view All
- **Followers Filter**: Set minimum follower count threshold
- **Real-time Updates**: Filters apply instantly as you type or change values
- **Clear Filters**: One-click filter reset

### 🎨 **Modern UI/UX**
- **Dark & Light Themes**: Automatic theme switching based on system preferences
- **Material Design**: Beautiful, responsive interface following Material Design guidelines
- **Loading States**: Clear visual feedback during file processing
- **Error Display**: User-friendly error messages with helpful guidance
- **Empty States**: Informative messages when no data or results are available

### 🏗️ **Clean Architecture**
- **Separation of Concerns**: Clear separation between data, domain, and presentation layers
- **State Management**: Provider pattern for efficient state management
- **Repository Pattern**: Abstracted data access layer
- **Reusable Components**: Modular, reusable widgets

## 📱 Screenshots

The app features a clean, modern interface with:
- Main screen with user list and filter controls
- Floating action button for loading CSV files
- Collapsible filter bar
- User cards displaying key information
- Error and loading states

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd File-loader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📖 Usage

### Loading a CSV File

1. Tap the **"Load CSV"** floating action button (bottom right)
2. Select a CSV file from your device
3. The app will automatically detect the file encoding and load the data
4. Users will be displayed in a scrollable list

### Applying Filters

1. Tap the **filter icon** in the app bar (appears after loading a file)
2. Enter filter criteria:
   - **Country**: Type country name (partial matches supported)
   - **Sex**: Select from dropdown (All, Male, Female)
   - **Min Followers**: Enter minimum follower count
3. Filters apply automatically as you type
4. Tap **"Clear Filters"** to reset all filters

### CSV File Format

The app expects CSV files with the following columns (case-sensitive):

| Column Name | Required | Description |
|------------|----------|-------------|
| `first_name` | ✅ Yes | User's first name |
| `last_name` | ✅ Yes | User's last name |
| `id` | ✅ Yes | Unique user identifier |
| `sex` | ❌ No | Gender (Male/Female) |
| `followers_count` | ❌ No | Number of followers (numeric) |
| `country_title` | ❌ No | Country name |
| `city_title` | ❌ No | City name |
| `last_seen` | ❌ No | Last seen timestamp |
| `bdate` | ❌ No | Birth date |
| `byear` | ❌ No | Birth year |
| `contacts` | ❌ No | Contact information |
| `connections` | ❌ No | Connection details |
| `can_write_private_message` | ❌ No | Permission flag |
| `can_post` | ❌ No | Permission flag |

**Example CSV:**
```csv
first_name,last_name,id,sex,followers_count,country_title,city_title
John,Doe,12345,Male,1500,United States,New York
Jane,Smith,67890,Female,2300,Canada,Toronto
```

### Supported File Encodings

The app automatically detects and handles the following encodings:

- ✅ **UTF-8** (default, recommended)
- ✅ **Windows-1251** (Cyrillic/Russian)
- ✅ **ISO-8859-1** (Latin-1, Western European)
- ✅ **Windows-1252** (Windows Latin-1 variant)
- ✅ **ISO-8859-15** (Latin-9)
- ✅ **CP866** (DOS Cyrillic)
- ✅ **KOI8-R** (Russian)

**Note**: UTF-8 is recommended for best compatibility. The app will automatically detect and use the correct encoding.

## 🏛️ Project Structure

```
lib/
├── core/                    # Core functionality
│   ├── constants/           # App-wide constants
│   ├── theme/              # Theme configuration
│   └── utils/              # Utility classes
│       ├── csv_parser.dart # CSV parsing logic
│       └── encoding_detector.dart # Encoding detection
├── data/                   # Data layer
│   ├── datasources/        # Data sources (local, remote)
│   ├── models/            # Data models
│   └── repositories/      # Repository implementations
├── features/              # Feature modules
│   └── users/            # User feature
│       ├── domain/       # Business logic
│       └── presentation/ # UI layer
│           ├── controllers/ # State management
│           ├── screens/    # Screen widgets
│           └── widgets/    # Feature-specific widgets
├── shared/               # Shared resources
│   ├── extensions/      # Dart extensions
│   └── widgets/        # Reusable widgets
└── main.dart           # App entry point
```

## 🛠️ Technologies Used

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Provider** - State management
- **file_picker** - File selection functionality
- **csv** - CSV parsing library
- **Material Design** - UI components and theming

## 🏗️ Architecture

The app follows **Clean Architecture** principles:

- **Presentation Layer**: UI components, controllers, and widgets
- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources, repositories, and models

### State Management

Uses **Provider** pattern for state management:
- `UserController` manages user data and filtering state
- Reactive UI updates through `Consumer` widgets
- Centralized state in controllers

### Data Flow

```
User Action → Controller → Repository → DataSource → File System
                ↓
            Update State
                ↓
            Notify Listeners
                ↓
            UI Updates
```

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 🐛 Troubleshooting

### CSV File Won't Load

**Problem**: "Failed to decode data using encoding 'utf-8'"

**Solutions**:
1. The app automatically tries multiple encodings - wait for it to complete
2. If it still fails, convert your CSV file to UTF-8:
   - Open in a text editor (Notepad++, VS Code)
   - Save as UTF-8 encoding
3. Ensure the file is a valid CSV file (not Excel .xlsx)

### Filters Not Working

- Ensure column names match exactly (case-sensitive)
- Check that filter values match the data format
- Country filter supports partial matches (e.g., "Unit" matches "United States")

### App Crashes on File Selection

- Ensure file picker permissions are granted
- Check that the selected file is not corrupted
- Verify the file is actually a CSV file

## 📝 Development

### Adding New Filters

1. Update `UserFilter` class in `lib/features/users/domain/user_filter.dart`
2. Add filter UI in `FilterBar` widget
3. Update `UserController` if needed

### Adding New CSV Columns

1. Add column constant in `AppConstants`
2. Update `UserModel` class
3. Update `CsvParser` if special parsing is needed

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors of the packages used in this project
- Material Design for design guidelines

## 📧 Support

For issues, questions, or suggestions, please open an issue on GitHub.

---

**Made with ❤️ using Flutter**
