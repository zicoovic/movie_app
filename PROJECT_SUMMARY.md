# 🎬 Movie App - Project Summary

## 🔄 HOW TO RESUME THIS PROJECT (Important!)

**If your computer crashes, you switch laptops, or start a new chat, tell Claude:**

```
"We worked together before. I'm learning Flutter. Keep explanations simple.
This is my movie app project - check PROJECT_SUMMARY.md for our progress.
We're following clean architecture with max 100 lines per file and we do the ui design 100% as the screen looks like .
Continue from where we left off."
```

**Working Style Reminders:**
- ✅ Explain concepts BEFORE coding
- ✅ Keep code simple (all devs can understand)
- ✅ Max 100 lines per file
- ✅ follow the ui design as the screen looks like
- ✅ Update PROJECT_SUMMARY.md after each step
- ✅ Tell me when to commit/push to Git
- ✅ Follow the 11 points from our first discussion

**Current Branch:** `develop`
**Last Commit:** `d73cbf2 - feat: Add Dependency Injection and Hive caching setup`

---

## 📱 Project Overview
A Flutter movie application using TMDB API with focus on clean architecture, professional practices, and learning modern Flutter development patterns.

**Screens:** 3 (Onboarding, Home, Movie Details)
**Architecture:** Clean Architecture (Feature-based)
**State Management:** Cubit (flutter_bloc)
**API:** The Movie Database (TMDB)
**TMDB API Key:** 29501a0da4990b898ff159bde85192f4 (stored in .env)

---

## 🎯 Assignment Requirements (Priority)
1. ✅ **Light/Dark Theming** - DONE with shared_preferences
2. ⏳ **Pagination** - Pending (will do with movie list)
3. ⏳ **Caching** - Pending (Hive setup next)
4. ⏳ **Error Logging** - Pending (Firebase Crashlytics later)

---

## 🏗️ Architecture Structure

```
lib/
├── core/                            # ✅ Shared utilities only
│   ├── error/                       # ✅ DONE
│   │   ├── failures.dart            # User-friendly errors
│   │   └── exceptions.dart          # Technical errors
│   ├── network/                     # ✅ DONE
│   │   ├── dio_client.dart          # HTTP client setup
│   │   └── api_constants.dart       # API URLs & endpoints
│   ├── theme/                       # ✅ DONE
│   │   ├── app_colors.dart          # Color constants
│   │   └── app_theme.dart           # Light/Dark themes
│   ├── usecases/                    # ✅ DONE
│   │   └── usecase.dart             # Base UseCase class
│   └── di/                          # ⏳ TODO
│       └── injection_container.dart # Dependency injection setup
│
├── features/                        # ✅ Clean arch: each feature separate
│   ├── theme/                       # ✅ DONE - Theme feature
│   │   └── presentation/
│   │       └── cubit/
│   │           └── theme_cubit.dart # Theme state management
│   │
│   ├── onboarding/                  # ⏳ TODO
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── movies/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── movie_model.dart         # JSON serializable
│   │   │   ├── datasources/
│   │   │   │   ├── movie_remote_datasource.dart
│   │   │   │   └── movie_local_datasource.dart  # Hive
│   │   │   └── repositories/
│   │   │       └── movie_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── movie.dart
│   │   │   ├── repositories/
│   │   │   │   └── movie_repository.dart    # Interface
│   │   │   └── usecases/
│   │   │       ├── get_popular_movies.dart
│   │   │       └── get_movie_details.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── movie_list_cubit.dart
│   │       │   ├── movie_list_state.dart
│   │       │   ├── movie_details_cubit.dart
│   │       │   └── movie_details_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── movie_details_page.dart
│   │       └── widgets/
│   │           ├── movie_card.dart
│   │           └── cast_item.dart
│
└── main.dart
```

---

## 📦 Core Packages

### Production Dependencies:
- `flutter_bloc` + `equatable` - State management (Cubit)
- `go_router` - Navigation
- `get_it` - Dependency injection
- `dio` - HTTP client
- `dartz` - Functional error handling (Either<Left, Right>)
- `json_annotation` + `json_serializable` - JSON parsing
- `hive` + `hive_flutter` - Local caching
- `shared_preferences` - Simple local storage (theme preference)
- `flutter_secure_storage` - Secure API token storage
- `cached_network_image` - Image caching
- `flutter_screenutil` - Responsive UI
- `firebase_core` + `firebase_crashlytics` - Error logging

### Dev Dependencies:
- `build_runner` - Code generation
- `hive_generator` - Hive adapters
- `mocktail` - Testing mocks
- `bloc_test` - Cubit/Bloc testing
- `flutter_native_splash` - Splash screen

---

## 🔄 Data Flow (Clean Architecture)

### Example: Getting Popular Movies

```
UI (HomePage)
    ↓ (user scrolls, triggers event)
MovieListCubit
    ↓ (calls)
GetPopularMoviesUseCase
    ↓ (calls)
MovieRepository (interface)
    ↓ (implemented by)
MovieRepositoryImpl
    ↓ (checks cache first)
MovieLocalDataSource (Hive)
    ↓ (if no cache or expired)
MovieRemoteDataSource (Dio/API)
    ↓ (returns)
Either<Failure, List<Movie>>
    ↓ (cubit emits state)
UI updates (shows movies or error)
```

**Why this flow?**
- **UI doesn't know about API or cache** - just asks Cubit
- **Cubit doesn't know about Dio or Hive** - just calls UseCase
- **UseCase doesn't know about implementation details** - just calls Repository interface
- **Easy to test** - we can mock each layer
- **Easy to change** - swap API? Just change data source, not use case!

---

## 🎨 Design System (Based on Figma)

### Colors:
- **Background Dark**: `#0F0F0F` (almost black)
- **Card Background**: `#1A1A1A` (slightly lighter)
- **Accent Gradient**: Cyan `#00D9FF` → Purple `#B84FFF`
- **Text Primary**: `#FFFFFF` (white)
- **Text Secondary**: `#8E8E93` (gray)

### Typography:
- **Title**: Bold, 24-28px
- **Body**: Regular, 14-16px
- **Caption**: Light, 12px

### Key UI Patterns:
1. **Gradient Buttons**: Horizontal gradient (cyan to purple) with rounded corners
2. **Gradient Borders**: Search bar, category cards
3. **Movie Posters**: Rounded corners (12px), shadow effect
4. **Circular Avatars**: Cast members (60px diameter)
5. **Horizontal Scroll**: Movie lists with spacing

---

## 🔐 Error Handling with Dartz

### Concept Explanation:
Instead of throwing exceptions or returning null, we use `Either<Left, Right>`:
- **Left** = Error (Failure)
- **Right** = Success (Data)

This **forces you to handle errors** everywhere!

### Example:
```dart
// UseCase returns Either
Either<Failure, List<Movie>> result = await getPopularMovies();

// In Cubit, we MUST handle both cases
result.fold(
  (failure) {
    // Left side = Error happened
    emit(MovieListError(failure.message));
  },
  (movies) {
    // Right side = Success!
    emit(MovieListLoaded(movies));
  },
);
```

### Failure Types:
```dart
abstract class Failure {
  final String message;
}

class ServerFailure extends Failure {
  // API returned 404, 500, etc.
}

class CacheFailure extends Failure {
  // Hive couldn't read data
}

class NetworkFailure extends Failure {
  // No internet connection
}
```

**Why not just try-catch?**
- `Either` is explicit - you can't forget to handle errors
- Type-safe - compiler ensures you check both cases
- Functional programming style - common in production apps

---

## 🧪 Testing Strategy

### What We'll Test:

**1. Unit Tests (UseCases & Cubits)**
```dart
// Example: Test GetPopularMovies UseCase
test('should return movie list from repository', () async {
  // Arrange: Setup mock
  when(() => mockRepository.getPopularMovies(page: 1))
    .thenAnswer((_) async => Right([movie1, movie2]));

  // Act: Call the use case
  final result = await usecase(page: 1);

  // Assert: Check result
  expect(result, Right([movie1, movie2]));
  verify(() => mockRepository.getPopularMovies(page: 1));
});
```

**2. Widget Tests (UI)**
```dart
// Example: Test if home page shows movies
testWidgets('displays movie list when loaded', (tester) async {
  // Arrange: Setup mock cubit
  when(() => mockCubit.state).thenReturn(MovieListLoaded([movie1]));

  // Act: Build widget
  await tester.pumpWidget(HomePage());

  // Assert: Check if movie title appears
  expect(find.text('Movie Title'), findsOneWidget);
});
```

**Coverage Goal:** 70%+

---

## 📡 TMDB API Details

### How to Get API Key:
1. Go to https://www.themoviedb.org/ (NOT developer.themoviedb.org)
2. Sign up for free account
3. Login → Settings → API → Request API Key
4. Choose "Developer"
5. Fill simple form (say it's for learning)
6. Get API key instantly!

### Base URL:
```
https://api.themoviedb.org/3
```

### Endpoints We'll Use:

**1. Popular Movies (with pagination)**
```
GET /movie/popular?page={page}

Response:
{
  "page": 1,
  "results": [
    {
      "id": 123,
      "title": "Movie Title",
      "poster_path": "/abc123.jpg",
      "overview": "Description...",
      "vote_average": 8.5
    }
  ],
  "total_pages": 500
}
```

**2. Movie Details**
```
GET /movie/{movie_id}
```

**3. Movie Credits (cast)**
```
GET /movie/{movie_id}/credits
```

### Authentication:
```dart
// Add to Dio headers
headers: {
  'Authorization': 'Bearer YOUR_API_KEY',
  'Content-Type': 'application/json',
}
```

---

## 🎯 Git Workflow

### Branches Strategy:
- **main** - Production ready code (protected)
- **develop** - Integration branch (we work from here)
- **feature/*** - Individual features

### Example Branches:
- `feature/project-setup`
- `feature/onboarding`
- `feature/home`
- `feature/details`
- `feature/theming`
- `feature/caching`
- `feature/firebase`

### Workflow:
```bash
# 1. Create feature branch from develop
git checkout develop
git checkout -b feature/onboarding

# 2. Work on feature, commit often
git add .
git commit -m "Add onboarding UI"

# 3. Merge back to develop
git checkout develop
git merge feature/onboarding

# 4. When everything is stable, merge to main
git checkout main
git merge develop
```

---

## 💾 Caching Strategy with Hive

### What is Hive?
- Super fast local database (NoSQL)
- Type-safe (uses code generation)
- Works like a key-value store
- Perfect for Flutter!

### What We'll Cache:
- ✅ Popular movies list (expires after 1 hour)
- ✅ Movie details (expires after 24 hours)
- ✅ User theme preference
- ✅ Onboarding shown status

### How It Works:
```dart
// 1. Define model with Hive annotations
@HiveType(typeId: 0)
class MovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime cachedAt;  // Track when cached
}

// 2. Check if cache is fresh
bool isCacheFresh(DateTime cachedAt) {
  return DateTime.now().difference(cachedAt).inHours < 1;
}

// 3. Use cache first, then API
Future<List<Movie>> getMovies() async {
  // Try cache first
  final cached = await localDataSource.getCachedMovies();
  if (cached != null && isCacheFresh(cached.cachedAt)) {
    return cached.movies;  // Return cached data
  }

  // If no cache or expired, fetch from API
  final movies = await remoteDataSource.getMovies();
  await localDataSource.cacheMovies(movies);  // Save for next time
  return movies;
}
```

---

## 🌓 Theming Implementation

### How Theme Switching Works:

**1. Create Theme Cubit**
```dart
class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;

  ThemeCubit(this.prefs) : super(ThemeMode.dark) {
    _loadTheme();  // Load saved preference
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
    emit(newMode);
    prefs.setString('theme', newMode.name);  // Save preference
  }
}
```

**2. Use in main.dart**
```dart
BlocBuilder<ThemeCubit, ThemeMode>(
  builder: (context, themeMode) {
    return MaterialApp.router(
      themeMode: themeMode,
      theme: AppTheme.lightTheme,      // Define light colors
      darkTheme: AppTheme.darkTheme,   // Define dark colors
      // ...
    );
  },
)
```

**3. Define Themes**
```dart
class AppTheme {
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF0F0F0F),
    // ... more customization
  );

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    // ... more customization
  );
}
```

---

## 📱 Pagination Implementation

### Strategy: Infinite Scroll

**When to load more?**
- When user scrolls to 80% of list
- Automatically loads next page
- Shows loading indicator at bottom

**Cubit Logic:**
```dart
class MovieListCubit extends Cubit<MovieListState> {
  int _currentPage = 1;
  bool _hasMore = true;
  List<Movie> _allMovies = [];

  Future<void> loadMovies() async {
    // First load
    emit(MovieListLoading());
    final result = await getPopularMovies(page: 1);
    // Handle result...
  }

  Future<void> loadMoreMovies() async {
    if (!_hasMore || state is MovieListLoadingMore) return;

    emit(MovieListLoadingMore(_allMovies));  // Show current + loading
    _currentPage++;

    final result = await getPopularMovies(page: _currentPage);
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (newMovies) {
        _allMovies.addAll(newMovies);
        _hasMore = newMovies.isNotEmpty;
        emit(MovieListLoaded(_allMovies));
      },
    );
  }
}
```

**UI Trigger:**
```dart
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    // When scrolled to 80%
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent * 0.8) {
      context.read<MovieListCubit>().loadMoreMovies();
    }
    return false;
  },
  child: ListView.builder(...)
)
```

---

## 🔥 Firebase Crashlytics Setup

### Why Firebase Crashlytics?
- **Automatic crash reporting** - catches all errors
- **Real-time alerts** - know when app crashes
- **Detailed stack traces** - find bugs easily
- **Free tier** - perfect for learning!

### Setup Steps (Brief):
1. Create Firebase project at https://console.firebase.google.com
2. Add Android app (package name: `com.example.movie_app`)
3. Download `google-services.json` → place in `android/app/`
4. Add iOS app (if needed)
5. Run FlutterFire CLI: `flutterfire configure`

### Usage in Code:
```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Catch all errors
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

// Manually log errors
try {
  await somethingRisky();
} catch (e, stack) {
  FirebaseCrashlytics.instance.recordError(e, stack);
}
```

---

## 📚 Key Learning Concepts

### 1. Clean Architecture
**Simple explanation:**
- **Data layer** = How we get data (API, cache)
- **Domain layer** = Business logic (what data means)
- **Presentation layer** = UI (what user sees)

**Why separate?**
- Change UI without touching API code
- Change API without touching business logic
- Easy to test each layer independently

### 2. Cubit (State Management)
**Simple explanation:**
- Cubit holds the state (loading, loaded, error)
- UI listens to Cubit
- When state changes, UI rebuilds automatically

**Example:**
```dart
// Cubit
class MovieListCubit extends Cubit<MovieListState> {
  void loadMovies() {
    emit(MovieListLoading());      // UI shows loading
    // ... fetch data ...
    emit(MovieListLoaded(movies)); // UI shows movies
  }
}

// UI
BlocBuilder<MovieListCubit, MovieListState>(
  builder: (context, state) {
    if (state is MovieListLoading) return CircularProgressIndicator();
    if (state is MovieListLoaded) return MovieList(state.movies);
    if (state is MovieListError) return ErrorWidget(state.message);
  },
)
```

### 3. Dependency Injection (get_it)
**Simple explanation:**
- Register all dependencies once at startup
- Get them anywhere in the app
- Easy to swap for testing (use mocks instead of real API)

**Example:**
```dart
// Register once
final sl = GetIt.instance;
sl.registerLazySingleton(() => Dio());
sl.registerLazySingleton(() => MovieRepository(sl()));

// Use anywhere
final repo = sl<MovieRepository>();
```

### 4. Repository Pattern
**Simple explanation:**
- Repository = Single place to get data
- Hides complexity (API vs cache)
- UseCase doesn't care where data comes from

**Example:**
```dart
class MovieRepositoryImpl implements MovieRepository {
  Future<Either<Failure, List<Movie>>> getMovies() async {
    // 1. Check cache first
    final cached = await localDataSource.getMovies();
    if (cached != null) return Right(cached);

    // 2. If no cache, fetch from API
    final movies = await remoteDataSource.getMovies();

    // 3. Save to cache for next time
    await localDataSource.cacheMovies(movies);

    return Right(movies);
  }
}
```

---

## 🚀 Development Flow (How We'll Work)

### Phase 1: Foundation (Days 1-2)
1. Setup Git (you run commands)
2. Add all packages to pubspec.yaml
3. Create folder structure
4. Setup Dio, get_it, error handling
5. **Goal:** Core infrastructure ready

### Phase 2: First Feature - Onboarding (Day 2)
1. Build UI matching design
2. Save "onboarding shown" flag
3. Navigate to home
4. **Goal:** Learn navigation, simple state

### Phase 3: Home Screen - Movies List (Days 3-5)
1. Create entire clean architecture (data → domain → presentation)
2. Implement Cubit with pagination
3. Build UI with movie cards
4. Add caching with Hive
5. **Goal:** Master clean architecture pattern

### Phase 4: Movie Details (Day 6)
1. Reuse same architecture pattern
2. Implement navigation with go_router
3. Fetch and display movie details
4. **Goal:** Reinforce architecture, navigation

### Phase 5: Theming (Day 7)
1. Create light/dark themes
2. Theme Cubit with shared_preferences
3. Add toggle button
4. **Goal:** Assignment requirement ✅

### Phase 6: Firebase & Testing (Days 8-9)
1. Setup Firebase Crashlytics
2. Write unit tests
3. Write widget tests
4. **Goal:** Production ready, all requirements ✅

---

## 🎯 Assignment Checklist

Before submission, verify:
- ✅ Light/Dark theming works
- ✅ Pagination loads more movies on scroll
- ✅ App works offline (cached data)
- ✅ Errors logged to Firebase Crashlytics
- ✅ All 3 screens match design
- ✅ Code follows clean architecture
- ✅ Tests written and passing

---

## 📋 The 11 Points We're Following

1. ✅ **OOP + SOLID** - Using interfaces, single responsibility
2. ✅ **Clean Architecture** - Data/Domain/Presentation layers, max 100 lines per file
3. ⏳ **Cubit (State Management)** - Using flutter_bloc (will implement with features)
4. ✅ **DI for HTTP** - get_it + Dio configured
5. ✅ **Error Handler** - dartz Either<Failure, Data> pattern
6. ⏳ **Git Flow** - develop branch, feature branches, descriptive commits
7. ⏳ **Testing** - Unit tests + widget tests (later)
8. ⏳ **CI/CD + Flavours** - Later phase
9. ⏳ **Firebase** - Crashlytics + Analytics (later)
10. ✅ **Theming** - Light/Dark with shared_preferences DONE
11. 🔄 **Caching + Token** - Hive setup done, will use in repositories

---

## 📋 Working Style Reminders

- ✅ **Explain before coding** - Concepts first, code second
- ✅ **Keep it simple** - Code all devs can understand
- ✅ **Comments in code** - For learning reference
- ✅ **You run Git commands** - I provide commands, you execute
- ✅ **Max 100 lines per file** - Clean, readable code
- ✅ **Follow the UI design** -  As the screen looks like
- ✅ **Update PROJECT_SUMMARY.md** - After each major step
- ✅ **Ask questions anytime** - No question is stupid!

---

## 🎯 CURRENT PROGRESS (Updated: 2025-10-30)

### ✅ Completed - Infrastructure Setup:
1. **Git Setup** - main and develop branches created
2. **Package Installation** - All dependencies added to pubspec.yaml
3. **Folder Structure** - Clean architecture folders created
4. **Error Handling** - Failures and Exceptions (simplified, user-friendly messages)
5. **API Configuration** - API constants and Dio client with interceptors
6. **Theme System** - Light/Dark theming (Assignment Req #1 ✅)
   - [app_colors.dart](lib/core/theme/app_colors.dart) (30 lines)
   - [app_theme.dart](lib/core/theme/app_theme.dart) (75 lines)
   - [theme_cubit.dart](lib/features/theme/presentation/cubit/theme_cubit.dart) (36 lines)
   - Saves preference with shared_preferences
7. **Dependency Injection** - get_it setup ✅
   - [injection_container.dart](lib/core/di/injection_container.dart) (38 lines)
   - Registers Dio, SharedPreferences, DioClient
   - Ready for repositories, use cases, cubits
8. **Hive Caching** - Local database initialized (Assignment Req #3 partial ✅)
   - [hive_helper.dart](lib/core/utils/hive_helper.dart) (30 lines)
   - Boxes opened: movies_box, movie_details_box
   - Ready to cache API responses

### ⏳ Next Steps (After Rest):
1. **Movie Domain Layer** - Create Movie entity (pure Dart class)
2. **Movie Data Layer** - Create Movie model with JSON serialization
3. **Movie Repository** - API calls + Caching logic
4. **Movie List UI** - Build home screen with pagination
5. **Onboarding Screen** - Simple UI matching design
6. **Movie Details Screen** - Show movie info with cast

### 📊 Assignment Requirements Status:
1. ✅ **Light/Dark Theming** - COMPLETE (toggles, saves preference)
2. ⏳ **Pagination** - Pending (will implement with movie list)
3. 🔄 **Caching** - Infrastructure ready (Hive initialized, will use in repository)
4. ⏳ **Error Logging** - Pending (Firebase setup later)

### 📝 Files Created (All < 100 lines, following clean arch):
- Core: 8 files (errors, network, theme, DI, utils)
- Features: 1 file (theme cubit)
- Total: ~350 lines of clean, readable code

---

**Last Updated:** 2025-10-30 (After DI + Hive Setup)
**Current Branch:** develop
**Status:** Core infrastructure complete, tested and working
**Next Step:** Push to GitHub, then start Movie feature tomorrow