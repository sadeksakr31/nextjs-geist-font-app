import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with mock configuration
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "mock-api-key",
        authDomain: "tripmate-mock.firebaseapp.com",
        projectId: "tripmate-mock",
        storageBucket: "tripmate-mock.appspot.com",
        messagingSenderId: "123456789",
        appId: "1:123456789:web:mock-app-id",
      ),
    );
  } catch (e) {
    // Mock Firebase initialization - will work with placeholder config
    print('Firebase initialization: Using mock configuration');
  }
  
  runApp(const TripMateApp());
}

class TripMateApp extends StatelessWidget {
  const TripMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseService()),
      ],
      child: MaterialApp(
        title: 'TripMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF1976D2),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarTheme(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF1976D2),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseService>(
      builder: (context, authService, child) {
        if (authService.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (authService.currentUser != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
