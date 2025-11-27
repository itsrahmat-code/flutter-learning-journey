import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Placeholder Imports (You need to replace these with your actual files) ---
import 'screens/home_screen.dart'; // Ensure this path is correct
import 'theme/theme_provider.dart'; // Ensure this path is correct

// Assuming you have these for AuthBloc and AuthService
// import 'bloc/auth_bloc.dart';
// import 'services/auth_service.dart';

// --- Placeholder Classes to make the code runnable for demonstration ---
// You MUST replace these with your actual AuthBloc and AuthService classes
class AuthService {}
class AuthBloc extends Bloc<dynamic, dynamic> {
  // Added non-null initial state for completeness (required by Bloc)
  AuthBloc(AuthService authService) : super(null);
}
// --------------------------------------------------------------------------


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(AuthService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ScreenUtilInit is used for responsive design
    return ScreenUtilInit(
      designSize: const Size(360, 690),

      // FIX: Remove the 'child' property from ScreenUtilInit.
      // Use the builder function to return the MaterialApp and define the home.
      builder: (ctx, widget) { // Using ctx instead of _, and widget instead of child for clarity
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Access the theme data from the ThemeProvider using Provider.of
          theme: Provider.of<ThemeProvider>(context).themeData,

          // FIX: Explicitly set the home widget inside the builder.
          // This ensures the widget uses a context (ctx) that is a descendant
          // of the providers in the MultiProvider defined in main().
          // Use AuthChecker here in a real app, but using HomeScreen for this snippet.
          home: const HomeScreen(),
        );
      },
    );
  }
}