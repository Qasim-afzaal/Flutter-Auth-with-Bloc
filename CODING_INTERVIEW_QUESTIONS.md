# Flutter Coding Interview Questions

## 🎯 Practical Coding Challenges

### Q1: Implement a Search with Debouncing

**Problem:** Create a search input that waits 500ms after user stops typing before searching.

**Solution:**
```dart
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<String> _results = [];

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    // Perform search
    setState(() {
      _results = ['Result 1', 'Result 2']; // Your search logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
    );
  }
}
```

---

### Q2: Implement Pagination with BLoC

**Problem:** Load items in pages (10 at a time) when user scrolls.

**Solution:**
```dart
// Event
class LoadMoreItems extends ItemsEvent {}

// State
class ItemsLoaded extends ItemsState {
  final List<Item> items;
  final bool hasMore;
  ItemsLoaded(this.items, this.hasMore);
}

// BLoC
Future<void> _onLoadMoreItems(
  LoadMoreItems event,
  Emitter<ItemsState> emit,
) async {
  final currentState = state as ItemsLoaded;
  if (!currentState.hasMore) return;

  emit(ItemsLoading(currentState.items));
  
  final newItems = await _repository.getItems(
    page: currentState.items.length ~/ 10 + 1,
  );
  
  emit(ItemsLoaded(
    [...currentState.items, ...newItems],
    newItems.length == 10, // hasMore
  ));
}
```

---

### Q3: Implement Error Handling with Retry

**Problem:** Show error with retry button when API call fails.

**Solution:**
```dart
// State
class ItemsError extends ItemsState {
  final String message;
  final VoidCallback onRetry;
  ItemsError(this.message, this.onRetry);
}

// BLoC
Future<void> _onLoadItems(...) async {
  try {
    emit(ItemsLoading());
    final items = await _repository.getItems();
    emit(ItemsLoaded(items));
  } catch (e) {
    emit(ItemsError(
      e.toString(),
      () => add(LoadItemsRequested()), // Retry
    ));
  }
}

// UI
BlocBuilder<ItemsBloc, ItemsState>(
  builder: (context, state) {
    if (state is ItemsError) {
      return Column(
        children: [
          Text(state.message),
          ElevatedButton(
            onPressed: state.onRetry,
            child: Text('Retry'),
          ),
        ],
      );
    }
    return Widget();
  },
)
```

---

### Q4: Implement Form Validation with BLoC

**Problem:** Validate form fields and show errors.

**Solution:**
```dart
// Event
class EmailChanged extends FormEvent {
  final String email;
  EmailChanged(this.email);
}

// State
class FormState {
  final String? emailError;
  final bool isValid;
}

// BLoC
void _onEmailChanged(EmailChanged event, Emitter<FormState> emit) {
  final emailError = _validateEmail(event.email);
  emit(FormState(emailError: emailError));
}

String? _validateEmail(String email) {
  if (email.isEmpty) return 'Email required';
  if (!email.contains('@')) return 'Invalid email';
  return null;
}
```

---

### Q5: Implement Caching Strategy

**Problem:** Cache API responses and show cached data while fetching new data.

**Solution:**
```dart
class DataRepository {
  final ApiService _api;
  final CacheService _cache;
  
  Future<List<Item>> getItems() async {
    // 1. Return cached data immediately
    final cached = await _cache.getItems();
    if (cached != null) {
      // Show cached data first
      // Then fetch fresh data
      _fetchFreshData();
      return cached;
    }
    
    // 2. Fetch from API
    final items = await _api.getItems();
    await _cache.saveItems(items);
    return items;
  }
  
  Future<void> _fetchFreshData() async {
    final items = await _api.getItems();
    await _cache.saveItems(items);
    // Emit new state with fresh data
  }
}
```

---

## 🎯 Architecture Coding Questions

### Q6: Implement Repository Pattern

**Problem:** Create a repository that can work with API or local storage.

**Solution:**
```dart
// Contract
abstract class UserRepository {
  Future<User> getUser(String id);
}

// API Implementation
class UserRepositoryImpl implements UserRepository {
  final ApiService _api;
  
  @override
  Future<User> getUser(String id) async {
    final response = await _api.get('/users/$id');
    return User.fromJson(response);
  }
}

// Mock Implementation (for testing)
class MockUserRepository implements UserRepository {
  @override
  Future<User> getUser(String id) async {
    return User(id: id, name: 'Test User');
  }
}
```

---

### Q7: Implement Dependency Injection

**Problem:** Set up dependency injection for your app.

**Solution:**
```dart
// GetIt setup
final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => ApiService());
  
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(apiService: sl()),
  );
  
  // BLoC
  sl.registerFactory(
    () => UserBloc(repository: sl()),
  );
}

// Usage
final bloc = sl<UserBloc>();
```

---

## 🔄 State Management Coding Questions

### Q8: Convert StatefulWidget to BLoC

**Problem:** Convert this StatefulWidget to use BLoC.

**Given:**
```dart
class CounterPage extends StatefulWidget {
  int _count = 0;
  
  void _increment() {
    setState(() => _count++);
  }
}
```

**Solution:**
```dart
// Event
class IncrementPressed extends CounterEvent {}

// State
class CounterState {
  final int count;
  CounterState(this.count);
}

// BLoC
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<IncrementPressed>(_onIncrementPressed);
  }
  
  void _onIncrementPressed(
    IncrementPressed event,
    Emitter<CounterState> emit,
  ) {
    emit(CounterState(state.count + 1));
  }
}

// UI
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    return Text('${state.count}');
  },
)
```

---

### Q9: Implement Loading States

**Problem:** Show loading, success, and error states.

**Solution:**
```dart
// States
abstract class DataState {}
class DataLoading extends DataState {}
class DataLoaded extends DataState {
  final List<Item> items;
  DataLoaded(this.items);
}
class DataError extends DataState {
  final String message;
  DataError(this.message);
}

// BLoC
Future<void> _onLoadData(...) async {
  emit(DataLoading());
  try {
    final items = await _repository.getItems();
    emit(DataLoaded(items));
  } catch (e) {
    emit(DataError(e.toString()));
  }
}

// UI
BlocBuilder<DataBloc, DataState>(
  builder: (context, state) {
    if (state is DataLoading) return CircularProgressIndicator();
    if (state is DataError) return Text(state.message);
    if (state is DataLoaded) return ListView(...);
    return SizedBox();
  },
)
```

---

## 🎓 Advanced Questions

### Q10: How do you handle deep linking?

**Answer:**
```dart
// GoRouter with deep links
GoRouter(
  routes: [
    GoRoute(
      path: '/user/:id',
      builder: (context, state) {
        final userId = state.pathParameters['id'];
        return UserPage(userId: userId);
      },
    ),
  ],
)

// Handle deep link
final uri = Uri.parse('myapp://user/123');
router.go(uri.path);
```

---

### Q11: How do you implement pull-to-refresh?

**Answer:**
```dart
RefreshIndicator(
  onRefresh: () async {
    context.read<ItemsBloc>().add(RefreshItemsRequested());
    await Future.delayed(Duration(seconds: 1));
  },
  child: ListView(...),
)
```

---

### Q12: How do you handle app lifecycle?

**Answer:**
```dart
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App in background
    } else if (state == AppLifecycleState.resumed) {
      // App in foreground
    }
  }
}
```

---

## 💡 Key Concepts to Remember

### BLoC:
- Events trigger handlers
- Handlers emit states
- UI rebuilds on state changes
- Use BlocBuilder for UI, BlocListener for side effects

### Clean Architecture:
- Domain = Business logic (independent)
- Data = External sources (depends on domain)
- Presentation = UI (depends on domain)

### State Management:
- Choose right tool for the job
- BLoC for complex, Provider for simple
- Don't over-engineer

### Best Practices:
- Use const constructors
- Dispose resources
- Handle errors properly
- Write tests
- Follow SOLID principles

---

## 🎯 Interview Strategy

1. **Understand the problem** - Ask clarifying questions
2. **Think out loud** - Explain your approach
3. **Start simple** - Build incrementally
4. **Handle edge cases** - Show you think about errors
5. **Write clean code** - Follow best practices
6. **Test your solution** - Verify it works

---

Good luck! You've got this! 🚀

