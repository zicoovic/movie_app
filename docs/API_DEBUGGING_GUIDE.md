# 🔍 API Debugging Guide - Your Personal Reference

**Created:** 2025-10-31
**Purpose:** Step-by-step guide to debug API errors in Flutter

---

## 📋 **Quick Checklist When API Fails**

When you see an error like "Server error" or no data loading:

1. ✅ Check console logs - Are there ANY logs at all?
2. ✅ Add print statements layer by layer (see below)
3. ✅ Follow the data flow from UI → API
4. ✅ Look for the LAST successful log - error is right after it
5. ✅ Check the error type (Dio, Cache, Server, etc.)
6. ✅ Verify configuration (Base URL, API key, DI container)

---

## 🏗️ **Understanding Data Flow in Clean Architecture**

```
UI (HomePage)
    ↓
Cubit (MovieListCubit)
    ↓
UseCase (GetPopularMovies)
    ↓
Repository (MovieRepositoryImpl)
    ↓
RemoteDataSource (MovieRemoteDataSourceImpl)
    ↓
HTTP Client (Dio via DioClient)
    ↓
TMDB API Server
```

**The error can happen at ANY layer!** We need to find which one.

---

## 📝 **Step-by-Step Debugging Process**

### **Step 1: Add Logs to Cubit**

**File:** `lib/features/movies/presentation/cubit/movie_list_cubit.dart`

```dart
Future<void> loadMovies() async {
  print('🎬 START: loadMovies() called');  // Did cubit start?
  emit(MovieListLoading());
  print('🎬 State changed to Loading');

  final result = await getPopularMovies(GetPopularMoviesParams(page: 1));
  print('🎬 Got result from UseCase');  // Did UseCase respond?

  result.fold(
    (failure) {
      print('🎬 ERROR from UseCase: ${failure.message}');  // What error?
      emit(MovieListError(failure.message));
    },
    (movies) {
      print('🎬 SUCCESS: Loaded ${movies.length} movies');  // How many?
      // ... rest of code
    },
  );
}
```

**What to check:**
- ✅ If you see "START: loadMovies() called" → Cubit is working
- ✅ If you see "Got result from UseCase" → UseCase is working
- ❌ If you see "ERROR from UseCase: Server error" → Problem is BELOW Cubit (in Repository or DataSource)

---

### **Step 2: Add Logs to Repository**

**File:** `lib/features/movies/data/repositories/movie_repository_impl.dart`

```dart
Future<Either<Failure, List<Movie>>> getPopularMovies({required int page}) async {
  try {
    print('📦 REPO: Checking cache for page $page');
    final cachedMovies = await localDataSource.getCachedPopularMovies(page);
    print('📦 REPO: Cache HIT - Found ${cachedMovies.length} movies');
    return Right(cachedMovies);
  } on CacheException catch (e) {
    print('📦 REPO: Cache MISS - ${e.message}');  // Expected on first run

    try {
      print('📦 REPO: Fetching from API...');
      final remoteMovies = await remoteDataSource.getPopularMovies(page);
      print('📦 REPO: API SUCCESS - Got ${remoteMovies.length} movies');

      await localDataSource.cachePopularMovies(remoteMovies, page);
      print('📦 REPO: Saved to cache');

      return Right(remoteMovies);
    } on ServerException catch (e) {
      print('📦 REPO: ServerException - ${e.message}');  // API error!
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      print('📦 REPO: NetworkException - ${e.message}');  // No internet!
      return Left(NetworkFailure(e.message));
    }
  }
}
```

**What to check:**
- ✅ "Checking cache" → Repository started
- ✅ "Cache MISS" → Normal for first time
- ✅ "Fetching from API..." → Repository trying to call API
- ❌ "ServerException" → Problem is in RemoteDataSource!

---

### **Step 3: Add Logs to RemoteDataSource**

**File:** `lib/features/movies/data/datasources/movie_remote_datasource.dart`

```dart
Future<List<MovieModel>> getPopularMovies(int page) async {
  try {
    print('🌍 REMOTE: About to call Dio for page $page');

    final response = await dio.get(
      ApiConstants.popularMovies,
      queryParameters: {
        'page': page,
        'api_key': ApiConstants.apiKey,
      },
    );

    print('🌍 REMOTE: Dio responded with status ${response.statusCode}');

    if (response.statusCode == 200) {
      final results = response.data['results'] as List;
      print('🌍 REMOTE: Parsing ${results.length} movies from JSON');
      return results.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw ServerException('API returned ${response.statusCode}');
    }
  } on DioException catch (e) {
    print('🌍 REMOTE: DioException - Type: ${e.type}');
    print('🌍 REMOTE: DioException - Message: ${e.message}');

    // This tells you WHAT went wrong with Dio
    if (e.type == DioExceptionType.connectionTimeout) {
      throw NetworkException('Connection timeout - API too slow');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NetworkException('No internet connection');
    } else if (e.type == DioExceptionType.unknown) {
      throw ServerException('Dio configuration error - check base URL');
    } else {
      throw ServerException(e.response?.data['status_message'] ?? 'Server error');
    }
  } catch (e) {
    print('🌍 REMOTE: Unexpected error - $e');
    throw ServerException('Unexpected error: $e');
  }
}
```

**What to check:**
- ✅ "About to call Dio" → RemoteDataSource started
- ✅ "Dio responded with status 200" → API call successful!
- ❌ "DioException - Type: unknown" → Dio configuration problem (like missing base URL)
- ❌ "DioException - Type: connectionError" → No internet
- ❌ "DioException - Type: connectionTimeout" → API too slow

---

### **Step 4: Check DioClient Logs**

**File:** `lib/core/network/dio_client.dart`

The DioClient has a built-in `_LoggingInterceptor` that automatically logs:

```dart
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🌐 HTTP REQUEST: ${options.method} ${options.path}');
    print('🌐 Params: ${options.queryParameters}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ HTTP SUCCESS: Status ${response.statusCode}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ HTTP ERROR: ${err.response?.statusCode}');
    print('❌ Error message: ${err.message}');
    super.onError(err, handler);
  }
}
```

**What to check:**
- ✅ If you see "HTTP REQUEST: GET /movie/popular" → Network call was made!
- ✅ If you see "HTTP SUCCESS: Status 200" → API responded successfully!
- ❌ If you see "HTTP ERROR: 404" → Wrong endpoint
- ❌ If you see "HTTP ERROR: 401" → Wrong API key
- ❌ If you DON'T see any HTTP logs → Dio was never called! (Configuration error)

---

## 🐛 **Common Error Types & Solutions**

### **Error 1: DioExceptionType.unknown**

**Symptoms:**
```
🌍 REMOTE: DioException - Type: unknown
📦 REPO: ServerException - Server error
```

**Cause:** Dio is not configured correctly (missing base URL, wrong setup)

**Solution:** Check DI container - make sure you're using configured Dio:
```dart
// WRONG ❌
getIt.registerLazySingleton(() => MovieRemoteDataSourceImpl(
  dio: getIt<Dio>()  // Raw Dio - no base URL!
));

// RIGHT ✅
getIt.registerLazySingleton(() => MovieRemoteDataSourceImpl(
  dio: getIt<DioClient>().dio  // Configured Dio with base URL
));
```

---

### **Error 2: DioExceptionType.connectionError**

**Symptoms:**
```
🌍 REMOTE: DioException - Type: connectionError
📦 REPO: NetworkException - No internet connection
```

**Cause:** Device has no internet connection

**Solution:**
- Check emulator/device WiFi
- Test in browser: Can you open google.com?
- Try disabling VPN if you have one

---

### **Error 3: DioExceptionType.badResponse (401)**

**Symptoms:**
```
❌ HTTP ERROR: 401
🌍 REMOTE: DioException - API returned 401
```

**Cause:** Invalid API key

**Solution:** Check `lib/core/network/api_constants.dart`:
```dart
static const String apiKey = 'YOUR_API_KEY_HERE';  // Is this correct?
```

Test your API key in Postman or browser:
```
https://api.themoviedb.org/3/movie/popular?api_key=YOUR_KEY
```

---

### **Error 4: No logs at all**

**Symptoms:**
- App shows error on screen
- Console is empty or very few logs

**Cause:**
- Cubit not being created (DI container issue)
- loadMovies() not being called
- Router not wrapping screen with BlocProvider

**Solution:** Check router setup:
```dart
GoRoute(
  path: '/home',
  builder: (context, state) => BlocProvider(
    create: (_) => getIt<MovieListCubit>()..loadMovies(),  // ← This calls loadMovies!
    child: const HomePage(),
  ),
),
```

---

## 📊 **Reading the Logs - Example**

### **Successful API Call:**
```
🎬 START: loadMovies() called
🎬 State changed to Loading
📦 REPO: Checking cache for page 1
📦 REPO: Cache MISS - No cached data
📦 REPO: Fetching from API...
🌍 REMOTE: About to call Dio for page 1
🌐 HTTP REQUEST: GET /movie/popular
🌐 Params: {page: 1, api_key: 29501...}
✅ HTTP SUCCESS: Status 200
🌍 REMOTE: Dio responded with status 200
🌍 REMOTE: Parsing 20 movies from JSON
📦 REPO: API SUCCESS - Got 20 movies
📦 REPO: Saved to cache
🎬 SUCCESS: Loaded 20 movies
```

**Analysis:** ✅ Everything working perfectly!

---

### **Failed API Call (No Base URL):**
```
🎬 START: loadMovies() called
🎬 State changed to Loading
📦 REPO: Checking cache for page 1
📦 REPO: Cache MISS - No cached data
📦 REPO: Fetching from API...
🌍 REMOTE: About to call Dio for page 1
🌍 REMOTE: DioException - Type: unknown      ← Problem here!
📦 REPO: ServerException - Server error
🎬 ERROR from UseCase: Server error
```

**Analysis:**
- ❌ No "HTTP REQUEST" log → Dio never made network call
- ❌ "DioException - Type: unknown" → Configuration problem
- **Solution:** Check if Dio has base URL configured

---

### **Failed API Call (Wrong API Key):**
```
🎬 START: loadMovies() called
📦 REPO: Fetching from API...
🌍 REMOTE: About to call Dio for page 1
🌐 HTTP REQUEST: GET /movie/popular
❌ HTTP ERROR: 401                           ← Problem here!
🌍 REMOTE: DioException - Type: badResponse
📦 REPO: ServerException - Invalid API key
🎬 ERROR from UseCase: Invalid API key
```

**Analysis:**
- ✅ Network call was made
- ❌ API returned 401 (Unauthorized)
- **Solution:** Check API key in api_constants.dart

---

## ✅ **Quick Reference: What Each Log Means**

| Log | Meaning |
|-----|---------|
| 🎬 START: loadMovies() | Cubit started working |
| 📦 REPO: Checking cache | Repository started |
| 📦 REPO: Cache MISS | No cached data (normal first time) |
| 📦 REPO: Fetching from API | About to call RemoteDataSource |
| 🌍 REMOTE: About to call Dio | RemoteDataSource started |
| 🌐 HTTP REQUEST: GET ... | Network call made (Dio working!) |
| ✅ HTTP SUCCESS: Status 200 | API responded successfully |
| 🌍 REMOTE: Parsing X movies | JSON parsing started |
| 📦 REPO: API SUCCESS | Repository got data from API |
| 📦 REPO: Saved to cache | Data cached for offline use |
| 🎬 SUCCESS: Loaded X movies | Everything worked! |
| ❌ HTTP ERROR: 401 | Wrong API key |
| ❌ HTTP ERROR: 404 | Wrong endpoint |
| 🌍 REMOTE: DioException | Dio had a problem |
| 📦 REPO: ServerException | API/Network error |

---

## 🎯 **Debugging Workflow Summary**

1. **Run the app** → See error on screen
2. **Check console** → Read ALL logs from bottom to top
3. **Find last successful log** → Error happened right after
4. **Identify the layer** → Which emoji stopped appearing?
   - 🎬 = Cubit layer
   - 📦 = Repository layer
   - 🌍 = RemoteDataSource layer
   - 🌐 = HTTP layer (Dio)
5. **Check error type** → DioException? ServerException? NetworkException?
6. **Match to common errors above** → Find solution
7. **Fix the issue** → Test again
8. **Remove debug logs** → When everything works

---

## 💡 **Pro Tips**

1. **Always start from the UI layer** (Cubit) and work down
2. **Don't skip layers** - check each one systematically
3. **Copy-paste logs** to a text file if they're too long
4. **Use emojis** in your prints - makes logs easy to scan
5. **Check DI container** if you see "unknown" errors
6. **Test API in browser/Postman** first to verify it works
7. **Keep this guide handy** - you'll use it often!

---

**Remember:** Every professional developer debugs like this. You're learning the RIGHT way! 🚀
