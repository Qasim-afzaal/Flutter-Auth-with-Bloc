import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth BLoC - Flutter Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        child: const AuthPage(),
      ),
    );
  }
}

