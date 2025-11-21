# EasyDB Hive

Hive storage implementation for [EasyDB](https://pub.dev/packages/easy_db) (<https://github.com/Dragon-InterActive/easy_db>). Provides fast, local key-value storage for Flutter applications.

## Features

- **Fast Performance**: Hive is optimized for mobile devices
- **Type-Safe**: Strongly typed operations
- **Zero Native Dependencies**: Pure Dart implementation
- **Offline-First**: Perfect for local data storage
- **Automatic Box Management**: Handles box opening/closing automatically

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_db: ^1.0.0
  easy_db_hive: ^1.0.0
```

## Usage

### Basic Setup

```dart
import 'package:easy_db/easy_db.dart';
import 'package:easy_db_hive/easy_db_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  db.configure(
    prefs: HiveDatabase(),
    // ... other configurations
  );
  
  await db.init();
  
  runApp(MyApp());
}
```

### Configuration File

In your `easy_db_config.dart`:

```dart
import 'package:easy_db/easy_db.dart';
import 'package:easy_db_hive/easy_db_hive.dart';

class EasyDBConfig {
  static DatabaseRepository get prefs => HiveDatabase();
  // ... other configurations
}
```

## Examples

### Store User Preferences

```dart
// Save theme preference
await db.prefs.set('settings', 'theme', {
  'mode': 'dark',
  'primaryColor': '#FF5722',
});

// Read preference
final theme = await db.prefs.get('settings', 'theme');
print(theme?['mode']); // dark

// Update preference
await db.prefs.update('settings', 'theme', {
  'mode': 'light',
});
```

### Store App State

```dart
// Save app state
await db.prefs.set('state', 'current', {
  'lastPage': '/home',
  'isLoggedIn': true,
  'timestamp': DatabaseRepository.serverTS, // Uses DateTime.now()
});

// Check if exists
if (await db.prefs.exists('state', 'current')) {
  final state = await db.prefs.get('state', 'current');
  print('Last page: ${state?['lastPage']}');
}
```

### Query Data

```dart
// Store multiple items
await db.prefs.set('tasks', 'task1', {'title': 'Buy milk', 'done': false});
await db.prefs.set('tasks', 'task2', {'title': 'Call John', 'done': true});
await db.prefs.set('tasks', 'task3', {'title': 'Read book', 'done': false});

// Query incomplete tasks
final incomplete = await db.prefs.query('tasks', 
  where: {'done': false}
);
print('Incomplete tasks: ${incomplete.length}'); // 2

// Get all tasks
final allTasks = await db.prefs.getAll('tasks');
print('Total tasks: ${allTasks?.length}'); // 3
```

### Delete Data

```dart
// Delete single item
await db.prefs.delete('settings', 'theme');

// Check existence before delete
if (await db.prefs.exists('settings', 'theme')) {
  await db.prefs.delete('settings', 'theme');
}
```

## Notes

- **No Encryption**: Hive data is not encrypted by default. Use `easy_db_secure_storage` for sensitive data.
- **Box Management**: Boxes are automatically opened when needed and remain open for the app lifetime.
- **Data Persistence**: All data is stored locally on the device.
- **Performance**: Hive is very fast for reads and writes, suitable for preferences and app state.

## When to Use

Use `easy_db_hive` for:

- ✅ User preferences and settings
- ✅ App configuration
- ✅ Cached data
- ✅ Offline-first applications
- ✅ Fast local storage needs

Don't use it for:

- ❌ Sensitive data (use `easy_db_secure_storage` instead)
- ❌ Large datasets (consider SQLite)
- ❌ Real-time sync (use `easy_db_firebase_realtime`)
- ❌ Complex queries (consider SQLite or Firestore)

## Hive Status

**Note**: Hive is no longer actively maintained (last update: 2021). While it's still stable and widely used, consider alternatives like:

- `easy_db_shared_preferences` for simple key-value storage
- `easy_db_sqlite` for complex local data (coming soon)

However, Hive remains a solid choice for local storage with excellent performance.

## License

BSD-3-Clause License - see LICENSE file for details.

Copyright (c) 2025, MasterNemo (Dragon Software)

---

Feel free to clone and extend. It's free to use and share.
