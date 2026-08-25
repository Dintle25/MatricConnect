# MatricConnect

A lightweight study hub for matric students — browse past papers, study guides, and
videos, bookmark them for offline reading, and never worry about wasted data doing it.

## Why it's built this way

Data costs are the whole problem this app solves, so almost every technical decision
traces back to that: cache the last successful list so a slow connection still shows
*something*, retry quietly before showing an error, and when an error does happen,
explain it in a sentence a Grade 12 student would actually understand instead of a
raw status code.
## Running it

```bash
flutter pub get

# Freezed and json_serializable generate code from the @freezed classes —
# this has to run once before the app will compile.
dart run build_runner build --delete-conflicting-outputs

# Dev flavor
flutter run -t lib/main_dev.dart

# Prod flavor
flutter run -t lib/main_prod.dart
```