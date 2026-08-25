# MatricConnect

A lightweight study hub for matric students — browse past papers, study guides, and
videos, bookmark them for offline reading, and never worry about wasted data doing it.

## Why it's built this way

Data costs are the whole problem this app solves, so almost every technical decision
traces back to that: cache the last successful list so a slow connection still shows
*something*, retry quietly before showing an error, and when an error does happen,
explain it in a sentence a Grade 12 student would actually understand instead of a
raw status code.

## Architecture

Feature-first, same pattern used across the other projects this term:

```
lib/
  core/                     # shared plumbing every feature can use
    config/                 # flavor (dev/prod) setup
    network/                # Dio client, interceptors, error → message mapping
    storage/                # secure token storage + local JSON cache
    router/                 # GoRouter + route path constants
    theme/                  # colors + Material 3 theme
    widgets/                # shared widgets (animated snackbar, bottom nav shell)
  features/
    auth/                   # login, session state
    resources/              # past papers / guides / videos, pagination
    bookmarks/              # offline-saved resources
    home/                   # dashboard
    profile/                # account + logout
```

## Meeting the brief

| Requirement | Where it lives |
|---|---|
| GoRouter + `StatefulShellRoute` for persistent tabs & deep links | `core/router/app_router.dart` — 4 tab branches, plus `/resources/:id` nested for deep links |
| Freezed models (copyWith, value equality, JSON) | `features/*/domain/*.dart` — `StudyResource`, `UserModel`, `ResourcePage`, `AuthState` (sealed union) |
| Dio with header + retry interceptors | `core/network/dio_client.dart`, `auth_interceptor.dart`, `retry_interceptor.dart` |
| Riverpod reactive dependency graph | Every provider in `presentation/providers/` — changing `subjectFilterProvider` automatically re-runs the resources fetch, no manual wiring |
| Secure token storage | `core/storage/secure_storage_service.dart` (flutter_secure_storage) |
| Paginated resource lists | `resources_provider.dart` — `loadMore()` triggered by scroll position |
| Friendly error → UI mapping (creativity) | `core/network/api_error_mapper.dart` + `core/widgets/status_snackbar.dart` — try the Download button on a resource a few times, it fails on purpose sometimes so you can see it live |
| Flavors (dev/prod) | `main_dev.dart` / `main_prod.dart` + `flavor_config.dart` |
| Codemagic CI | `codemagic.yaml` |

## About the "backend"

There's no real API for this demo. `MockResourcesRemoteDataSource` stands in for
one — real delay, real pagination, and it genuinely throws `DioException`s with
realistic status codes about 1 in 24 requests, so the retry logic and the friendly
error messages have something real to react to instead of being described in a
comment. `DioResourcesRemoteDataSource` is written and ready for when a real API
exists — swap which one gets created in `resources_provider.dart` and nothing else
in the app needs to change.

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

## What to look at during a demo

1. **Login** — any name/school works, it's a mock backend.
2. **Home tab** — subject shortcuts jump into Resources pre-filtered.
3. **Resources tab** — scroll to the bottom to trigger pagination; pull down to refresh.
   Keep scrolling/refreshing and you'll eventually see the friendly error banner —
   that's the mock "flaky network" doing its job.
4. **Tap a resource → Download** — sometimes fails on purpose, shows the animated
   error snackbar with a Retry button that actually retries.
5. **Bookmark a few resources**, then check the **Saved tab** — still there after
   closing and reopening the app (real local storage, not just in-memory state).
6. **Deep link test**: `matricconnect://resources/res-3` opens the detail screen
   directly with the Resources tab selected.
