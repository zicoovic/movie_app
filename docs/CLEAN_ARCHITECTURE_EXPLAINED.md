# 🏗️ Clean Architecture - Complete Explanation

**Created:** 2025-11-01
**Purpose:** Detailed explanation of all files and how they work together

---

## 📚 Table of Contents

1. [What is Clean Architecture?](#what-is-clean-architecture)
2. [The Three Layers](#the-three-layers)
3. [File-by-File Explanation](#file-by-file-explanation)
4. [How Data Flows](#how-data-flows)
5. [Why We Do This](#why-we-do-this)

---

## 🎯 What is Clean Architecture?

**Simple Definition:**
Clean Architecture is like organizing a restaurant:
- **Kitchen** (Data Layer) = Where food is prepared (API calls, database)
- **Menu & Recipes** (Domain Layer) = What dishes exist and how to make them (business logic)
- **Waiters & Dining Area** (Presentation Layer) = What customers see and interact with (UI)

**Key Rule:** Inner layers DON'T know about outer layers
- Kitchen doesn't know about waiters
- But waiters know about kitchen

**In code:**
- Domain layer doesn't know about UI or API
- But UI and API know about Domain

---

## 🏗️ The Three Layers

```
┌─────────────────────────────────────────┐
│     PRESENTATION LAYER (UI)             │
│  - Pages (Screens)                      │
│  - Widgets (UI components)              │
│  - Cubits (State management)            │
│                                         │
│  Depends on ↓                           │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│     DOMAIN LAYER (Business Logic)       │
│  - Entities (Data models - pure Dart)   │
│  - UseCases (Business rules)            │
│  - Repository Interfaces (Contracts)    │
│                                         │
│  Depends on ↓                           │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│     DATA LAYER (Data Sources)           │
│  - Models (JSON + Hive serialization)   │
│  - Repository Implementations           │
│  - Remote DataSource (API)              │
│  - Local DataSource (Hive cache)        │
└─────────────────────────────────────────┘
```

---

## 📁 File-by-File Explanation

### **1. DOMAIN LAYER - UseCase**

**File:** `lib/features/movies/domain/usecases/get_popular_movies.dart`

**What it does:** Contains the business logic for "getting popular movies"

**Line-by-line:**

```dart
// Line 16: Define the UseCase class
class GetPopularMovies implements UseCase<List<Movie>, GetPopularMoviesParams> {
  // UseCase<OUTPUT, INPUT>
  // OUTPUT = List<Movie> (what we get back)
  // INPUT = GetPopularMoviesParams (what we send: page number)

  // Line 17: Dependency - the repository interface
  final MovieRepository repository;

  // Line 19: Constructor - inject repository
  GetPopularMovies(this.repository);
  // Why inject? So we can swap with fake repository for testing

  // Line 22-24: The actual work
  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
  // call() makes this class callable like a function
  // We just pass the request to repository
}

// Line 28-32: Parameters class
class GetPopularMoviesParams {
  final int page;  // Page number (1, 2, 3...)

  GetPopularMoviesParams({required this.page});
}
// Why separate class? Clean code
// If we need more params later (category, language), just add fields
```

**Real-world analogy:**
- **UseCase** = Recipe for making a dish
- **Repository** = The kitchen (where ingredients come from)
- **Params** = The order (page 1, page 2, etc.)

**Why UseCase exists:**
- ✅ Single place for business rules
- ✅ Reusable (can be called from multiple Cubits)
- ✅ Easy to test (mock the repository)
- ✅ If logic gets complex, it's all in one place

---

### **2. DOMAIN LAYER - Repository Interface**

**File:** `lib/features/movies/domain/repositories/movie_repository.dart`

**What it does:** Defines the contract (promise) of what operations exist

**Line-by-line:**

```dart
// Line 14: Abstract class = Interface (no implementation)
abstract class MovieRepository {
  // abstract = You CAN'T create instance of this
  // It's just a contract

  // Line 22-24: Method signature (no body)
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    required int page,
  });
  // This says: "Whoever implements this MUST have this method"

  // Line 33-35: Another method signature
  Future<Either<Failure, Movie>> getMovieDetails({
    required int movieId,
  });
}
```

**Real-world analogy:**
- **Interface** = Restaurant menu (lists available dishes)
- **Implementation** = Kitchen (actually cooks the food)
- **Customer (UseCase)** = Orders from menu, doesn't know how food is made

**Why interface exists:**
- ✅ Domain layer doesn't care HOW we get data (API? Database? File?)
- ✅ Easy to swap implementations (use fake data for testing)
- ✅ Follows Dependency Inversion Principle (SOLID)

**Example:**
```dart
// For testing:
class FakeMovieRepository implements MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({required int page}) {
    return Right([Movie(title: "Test Movie")]);  // No real API!
  }
}

// For production:
class RealMovieRepository implements MovieRepository {
  // ... real API calls
}

// UseCase doesn't change! It just calls repository.getPopularMovies()
```

---

### **3. DATA LAYER - Repository Implementation**

**File:** `lib/features/movies/data/repositories/movie_repository_impl.dart`

**What it does:** Implements the cache-first strategy to get movies

**The Cache-First Strategy:**

```
┌─────────────────────────────────────┐
│   Repository.getPopularMovies()     │
└─────────────────────────────────────┘
              ↓
    ┌─────────────────┐
    │ Check Cache     │ ← Fast! Works offline!
    └─────────────────┘
              ↓
        Found in cache?
         /        \
       YES         NO
        ↓           ↓
    Return     Call API
    cached     Save to cache
    data       Return fresh data
```

**Line-by-line:**

```dart
// Line 18: Implements the interface we saw earlier
class MovieRepositoryImpl implements MovieRepository {
  // "implements" = This class MUST have all methods from MovieRepository

  // Line 19-20: Two data sources
  final MovieRemoteDataSource remoteDataSource;  // Talks to API
  final MovieLocalDataSource localDataSource;    // Talks to Hive

  // Line 22-25: Constructor - inject both
  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Line 28-61: The main method - get popular movies
  Future<Either<Failure, List<Movie>>> getPopularMovies({
    required int page,
  }) async {

    // STEP 1: Try cache first (lines 31-36)
    try {
      final cachedMovies = await localDataSource.getCachedPopularMovies(page);
      return Right(cachedMovies);  // ✅ Cache hit! Return immediately
    }

    // STEP 2: Cache failed (lines 37-56)
    on CacheException catch (e) {
      // Cache is empty or expired

      try {
        // Get fresh data from API
        final remoteMovies = await remoteDataSource.getPopularMovies(page);

        // Save to cache for next time
        await localDataSource.cachePopularMovies(remoteMovies, page);

        return Right(remoteMovies);  // ✅ Return fresh data
      }

      // STEP 3: Convert exceptions to failures (lines 50-56)
      on ServerException catch (e) {
        return Left(ServerFailure(e.message));  // ❌ API error
      }
      on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));  // ❌ No internet
      }
    }
  }
}
```

**Why convert Exception → Failure?**

```
DATA LAYER speaks:              DOMAIN LAYER speaks:
- ServerException               - ServerFailure
- NetworkException              - NetworkFailure
- CacheException                - CacheFailure

Repository translates between them!
```

**Benefits:**
- Domain layer doesn't know about technical errors (ServerException)
- Domain only knows about user-friendly failures (ServerFailure)
- Each layer has its own "language"

---

### **4. DATA LAYER - Remote Data Source (API)**

**File:** `lib/features/movies/data/datasources/movie_remote_datasource.dart`

**What it does:** Makes HTTP requests to TMDB API

**Line-by-line:**

```dart
// Line 10-13: Interface
abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies(int page);
  Future<MovieModel> getMovieDetails(int movieId);
}

// Line 15: Implementation
class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {

  // Line 16: Dio - HTTP client
  final Dio dio;

  // Line 21-56: Get popular movies method
  Future<List<MovieModel>> getPopularMovies(int page) async {
    try {

      // STEP 1: Make HTTP request (lines 24-30)
      final response = await dio.get(
        ApiConstants.popularMovies,              // '/movie/popular'
        queryParameters: {
          'page': page,                          // ?page=1
          'api_key': ApiConstants.apiKey,        // &api_key=YOUR_KEY
        },
      );
      // Full URL: https://api.themoviedb.org/3/movie/popular?page=1&api_key=...

      // STEP 2: Check status code (line 33)
      if (response.statusCode == 200) {
        // Success!

        // STEP 3: Parse JSON to Dart objects (lines 34-36)
        final results = response.data['results'] as List;
        // response.data = the JSON object
        // response.data['results'] = array of movie objects

        return results.map((json) => MovieModel.fromJson(json)).toList();
        // Convert each JSON object to MovieModel
      } else {
        throw ServerException('Failed to load movies');
      }

    }

    // STEP 4: Handle errors (lines 40-55)
    on DioException catch (e) {
      // Dio-specific errors

      if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException('Connection timeout');
        // API took too long to respond
      }

      else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
        // Device has no internet
      }

      else {
        throw ServerException('Server error');
        // Other API errors (404, 500, etc.)
      }
    }
  }
}
```

**What happens step-by-step:**

1. **Request sent:**
   ```
   GET https://api.themoviedb.org/3/movie/popular?page=1&api_key=29501...
   ```

2. **TMDB responds with JSON:**
   ```json
   {
     "page": 1,
     "results": [
       {
         "id": 123,
         "title": "Movie Title",
         "poster_path": "/abc.jpg",
         "vote_average": 8.5
       },
       // ... 19 more movies
     ]
   }
   ```

3. **Parse JSON:**
   - Extract `results` array
   - Convert each object to `MovieModel`
   - Return list of `MovieModel`

---

### **5. DATA LAYER - Local Data Source (Hive)**

**File:** `lib/features/movies/data/datasources/movie_local_datasource.dart`

**What it does:** Saves and retrieves movies from Hive (local database)

**Quick summary:**

```dart
class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box moviesBox;  // Hive storage for movie lists

  // Get cached movies
  Future<List<MovieModel>> getCachedPopularMovies(int page) async {
    final key = 'popular_page_$page';  // e.g., 'popular_page_1'
    final cached = moviesBox.get(key);

    if (cached == null) {
      throw CacheException('No cached data');  // Not found
    }

    final movies = (cached as List).cast<MovieModel>();

    // Check if cache is fresh (< 1 hour)
    if (movies.first.isCacheFresh) {
      return movies;  // ✅ Fresh cache
    } else {
      throw CacheException('Cache expired');  // ❌ Too old
    }
  }

  // Save movies to cache
  Future<void> cachePopularMovies(List<MovieModel> movies, int page) async {
    final key = 'popular_page_$page';
    await moviesBox.put(key, movies);  // Save to Hive
  }
}
```

**How cache expiry works:**

```dart
// In MovieModel:
class MovieModel {
  final DateTime cachedAt;  // When we saved it

  bool get isCacheFresh {
    // Check if less than 1 hour old
    return DateTime.now().difference(cachedAt).inHours < 1;
  }
}
```

---

### **6. PRESENTATION LAYER - Cubit (State Management)**

**File:** `lib/features/movies/presentation/cubit/movie_list_cubit.dart`

**What it does:** Manages the state of the movie list screen

**States:**
```dart
// Initial - nothing happened yet
class MovieListInitial extends MovieListState {}

// Loading - fetching first page
class MovieListLoading extends MovieListState {}

// Loading More - fetching next page
class MovieListLoadingMore extends MovieListState {
  final List<Movie> currentMovies;  // Keep showing current movies
}

// Loaded - success!
class MovieListLoaded extends MovieListState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasMore;  // Are there more pages?
}

// Error - something failed
class MovieListError extends MovieListState {
  final String message;
}
```

**Main methods:**

```dart
class MovieListCubit extends Cubit<MovieListState> {
  final GetPopularMovies getPopularMovies;  // UseCase

  int _currentPage = 0;       // Track current page
  List<Movie> _allMovies = [];   // All movies loaded so far
  bool _hasMore = true;       // More pages to load?

  // Load first page
  Future<void> loadMovies() async {
    // 1. Emit loading state
    emit(MovieListLoading());
    // → UI shows: CircularProgressIndicator

    // 2. Call UseCase
    final result = await getPopularMovies(GetPopularMoviesParams(page: 1));

    // 3. Handle result
    result.fold(
      (failure) {
        // Error happened
        emit(MovieListError(failure.message));
        // → UI shows: Error message
      },
      (movies) {
        // Success!
        _currentPage = 1;
        _allMovies.clear();
        _allMovies.addAll(movies);
        _hasMore = movies.length >= 20;  // TMDB returns 20 per page

        emit(MovieListLoaded(
          movies: _allMovies,
          currentPage: _currentPage,
          hasMore: _hasMore,
        ));
        // → UI shows: List of movies
      },
    );
  }

  // Load more movies (pagination)
  Future<void> loadMoreMovies() async {
    // Don't load if already loading or no more pages
    if (state is MovieListLoadingMore || !_hasMore) return;

    // 1. Emit loading more state (keep showing current movies)
    emit(MovieListLoadingMore(_allMovies));
    // → UI shows: Current movies + loading indicator at bottom

    // 2. Load next page
    _currentPage++;
    final result = await getPopularMovies(GetPopularMoviesParams(page: _currentPage));

    // 3. Handle result
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (newMovies) {
        _allMovies.addAll(newMovies);  // Add to existing list
        _hasMore = newMovies.length >= 20;

        emit(MovieListLoaded(
          movies: _allMovies,
          currentPage: _currentPage,
          hasMore: _hasMore,
        ));
        // → UI shows: Old movies + new movies
      },
    );
  }
}
```

**How UI listens:**

```dart
// In HomePage:
BlocBuilder<MovieListCubit, MovieListState>(
  builder: (context, state) {
    // UI rebuilds automatically when state changes

    if (state is MovieListLoading) {
      return CircularProgressIndicator();  // Show spinner
    }

    if (state is MovieListLoaded) {
      return ListView.builder(
        itemCount: state.movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: state.movies[index]);
        },
      );
    }

    if (state is MovieListError) {
      return Text('Error: ${state.message}');
    }

    return SizedBox();  // Initial state
  },
)
```

---

## 🔄 How Data Flows (Complete Journey)

Let's follow what happens when user opens the app:

### **Step-by-Step Flow:**

```
1. USER OPENS APP
   ↓
2. Router creates HomePage with MovieListCubit
   GoRoute(
     path: '/home',
     builder: (context, state) => BlocProvider(
       create: (_) => getIt<MovieListCubit>()..loadMovies(),  ← Calls loadMovies!
       child: const HomePage(),
     ),
   )
   ↓
3. CUBIT: loadMovies() called
   emit(MovieListLoading());  ← UI shows spinner
   ↓
4. CUBIT: Calls UseCase
   final result = await getPopularMovies(GetPopularMoviesParams(page: 1));
   ↓
5. USECASE: Calls Repository
   return await repository.getPopularMovies(page: 1);
   ↓
6. REPOSITORY: Checks cache first
   try {
     final cached = await localDataSource.getCachedPopularMovies(1);
     return Right(cached);  // ← If found, return here!
   }
   ↓
7. CACHE MISS (first time running)
   Throws CacheException
   ↓
8. REPOSITORY: Calls API
   final movies = await remoteDataSource.getPopularMovies(1);
   ↓
9. REMOTE DATA SOURCE: HTTP request
   final response = await dio.get(
     '/movie/popular',
     queryParameters: {'page': 1, 'api_key': '...'},
   );
   ↓
10. TMDB API: Responds with JSON
    {
      "results": [
        {"id": 123, "title": "Movie 1", ...},
        {"id": 124, "title": "Movie 2", ...},
        ...
      ]
    }
   ↓
11. REMOTE DATA SOURCE: Parse JSON
    return results.map((json) => MovieModel.fromJson(json)).toList();
    ↓ Returns List<MovieModel>
    ↓
12. REPOSITORY: Save to cache
    await localDataSource.cachePopularMovies(movies, 1);
    return Right(movies);
    ↓ Returns Either<Failure, List<Movie>>
    ↓
13. USECASE: Pass through
    return result;  // Either<Failure, List<Movie>>
    ↓
14. CUBIT: Handle result
    result.fold(
      (failure) => emit(MovieListError(failure.message)),
      (movies) {
        _allMovies = movies;
        emit(MovieListLoaded(movies: movies));  ← UI updates!
      },
    );
    ↓
15. UI: BlocBuilder rebuilds
    if (state is MovieListLoaded) {
      return ListView.builder(...)  ← Shows movies!
    }
    ↓
16. USER SEES MOVIES! 🎉
```

### **Next time user opens app:**

```
1-6. Same as above
   ↓
7. REPOSITORY: Checks cache
   final cached = await localDataSource.getCachedPopularMovies(1);
   ↓
8. CACHE HIT! (movies saved from last time)
   if (cached.first.isCacheFresh) {  // Less than 1 hour old?
     return Right(cached);  ← Return immediately! No API call!
   }
   ↓
9-16. Skip API, show cached movies instantly!
```

**Benefits:**
- ✅ **First load:** Fetches from API (2-3 seconds)
- ✅ **Next load:** Shows cached data instantly (< 100ms)
- ✅ **Works offline:** If no internet, still shows cached movies
- ✅ **Auto-refresh:** Cache expires after 1 hour, gets fresh data

---

## 💡 Why We Do This

### **Problem 1: Spaghetti Code**

**Bad approach (without clean architecture):**
```dart
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    // API call directly in UI!
    final dio = Dio();
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {'api_key': '...'},
    );

    // JSON parsing in UI!
    final results = response.data['results'] as List;
    setState(() {
      movies = results.map((json) {
        return Movie(
          id: json['id'],
          title: json['title'],
          // ...
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieCard(movie: movies[index]),
    );
  }
}
```

**Problems:**
- ❌ Can't test without building UI
- ❌ Can't reuse in other screens
- ❌ No caching
- ❌ No error handling
- ❌ Hard to change API (have to change UI code!)

---

### **Solution: Clean Architecture**

**Good approach:**
```dart
// UI just displays data
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListCubit, MovieListState>(
      builder: (context, state) {
        if (state is MovieListLoaded) {
          return ListView.builder(
            itemCount: state.movies.length,
            itemBuilder: (context, index) => MovieCard(movie: state.movies[index]),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
```

**Benefits:**
- ✅ UI only knows about Cubit
- ✅ Cubit only knows about UseCase
- ✅ UseCase only knows about Repository
- ✅ Easy to test each layer separately
- ✅ Easy to change (swap API, change UI, etc.)

---

## 🧪 Testing Benefits

**With Clean Architecture:**

```dart
// Test UseCase (no UI, no API)
test('should get popular movies from repository', () async {
  // Mock repository
  when(() => mockRepository.getPopularMovies(page: 1))
    .thenAnswer((_) async => Right([movie1, movie2]));

  // Test UseCase
  final result = await useCase(GetPopularMoviesParams(page: 1));

  // Verify
  expect(result, Right([movie1, movie2]));
  verify(() => mockRepository.getPopularMovies(page: 1));
});

// Test Cubit (no API)
blocTest(
  'emits [Loading, Loaded] when loadMovies succeeds',
  build: () {
    when(() => mockUseCase(any()))
      .thenAnswer((_) async => Right([movie1]));
    return MovieListCubit(getPopularMovies: mockUseCase);
  },
  act: (cubit) => cubit.loadMovies(),
  expect: () => [
    MovieListLoading(),
    MovieListLoaded(movies: [movie1]),
  ],
);

// Test Repository (no UI, no Cubit)
test('should return cached data when cache is fresh', () async {
  // Mock cache
  when(() => mockLocalDataSource.getCachedPopularMovies(1))
    .thenAnswer((_) async => [movieModel1]);

  // Test repository
  final result = await repository.getPopularMovies(page: 1);

  // Verify: Should return cached data without calling API
  expect(result, Right([movieModel1]));
  verifyNever(() => mockRemoteDataSource.getPopularMovies(any()));
});
```

**Without Clean Architecture:**
- You'd have to build the entire UI to test anything
- Can't test without making real API calls
- Tests are slow and brittle

---

## 📊 Summary Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │ HomePage │  │  Cubit   │  │  States  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│       ↓              ↓              ↓                    │
└───────────────────────────────────────────────────────┬─┘
                                                         │
                                                         │ Calls
                                                         ↓
┌─────────────────────────────────────────────────────────┐
│                      DOMAIN                              │
│  ┌──────────┐  ┌──────────────┐  ┌─────────────┐       │
│  │  Entity  │  │   UseCase    │  │ Repository  │       │
│  │  (Movie) │  │(Get Movies)  │  │ (Interface) │       │
│  └──────────┘  └──────────────┘  └─────────────┘       │
│                       ↓                    ↓             │
└───────────────────────────────────────────────────────┬─┘
                                                         │
                                                         │ Implements
                                                         ↓
┌─────────────────────────────────────────────────────────┐
│                       DATA                               │
│  ┌──────────────┐  ┌─────────────┐  ┌─────────────┐    │
│  │  Model       │  │ Repository  │  │ DataSources │    │
│  │(JSON + Hive) │  │   Impl      │  │(API + Hive) │    │
│  └──────────────┘  └─────────────┘  └─────────────┘    │
│                           ↓                              │
└───────────────────────────────────────────────────────┬─┘
                                                         │
                                                         │ Fetches
                                                         ↓
                                                  ┌──────────┐
                                                  │ TMDB API │
                                                  └──────────┘
```

---

## 🎓 Key Takeaways

1. **Separation of Concerns**
   - Each layer has ONE job
   - UI = Display
   - Domain = Business logic
   - Data = Get/save data

2. **Dependency Rule**
   - Outer layers depend on inner
   - Inner layers DON'T know about outer
   - Domain is the center (most stable)

3. **Testability**
   - Each layer can be tested independently
   - Mock dependencies easily
   - Fast tests (no UI, no real API)

4. **Maintainability**
   - Change one layer without affecting others
   - Swap implementations easily
   - Clear structure, easy to navigate

5. **Scalability**
   - Add new features following same pattern
   - Reuse UseCases across app
   - Consistent code style

---

**Read this anytime you need a refresher!** 📚

---

**Created with ❤️ for learning Flutter**
