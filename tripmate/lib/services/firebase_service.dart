import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip.dart';

class FirebaseService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FirebaseService() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Email/Password Authentication
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Mock authentication for demo purposes
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate successful login
      _currentUser = MockUser(email: email);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign in: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Mock registration for demo purposes
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate successful registration
      _currentUser = MockUser(email: email);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign up: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Google Sign In (Mock implementation)
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);
      
      // Mock Google sign in for demo purposes
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate successful Google login
      _currentUser = MockUser(email: 'user@gmail.com', displayName: 'Demo User');
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to sign in with Google: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to sign out: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Firestore Operations (Mock implementations)
  Future<List<Trip>> getUserTrips() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock trips data
      return [
        Trip(
          id: '1',
          title: 'Paris Adventure',
          destination: 'Paris, France',
          startDate: DateTime.now().add(const Duration(days: 30)),
          endDate: DateTime.now().add(const Duration(days: 37)),
          travelers: ['John Doe', 'Jane Smith'],
          activities: [],
          expenses: [],
        ),
        Trip(
          id: '2',
          title: 'Tokyo Explorer',
          destination: 'Tokyo, Japan',
          startDate: DateTime.now().add(const Duration(days: 60)),
          endDate: DateTime.now().add(const Duration(days: 70)),
          travelers: ['John Doe'],
          activities: [],
          expenses: [],
        ),
      ];
    } catch (e) {
      _setError('Failed to load trips: ${e.toString()}');
      return [];
    }
  }

  Future<bool> saveTrip(Trip trip) async {
    try {
      _setLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock save operation
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to save trip: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteTrip(String tripId) async {
    try {
      _setLoading(true);
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock delete operation
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete trip: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }
}

// Mock User class for demo purposes
class MockUser extends User {
  final String _email;
  final String? _displayName;

  MockUser({required String email, String? displayName})
      : _email = email,
        _displayName = displayName;

  @override
  String? get email => _email;

  @override
  String? get displayName => _displayName;

  @override
  String get uid => 'mock-uid-${_email.hashCode}';

  @override
  bool get emailVerified => true;

  @override
  bool get isAnonymous => false;

  @override
  UserMetadata get metadata => MockUserMetadata();

  @override
  List<UserInfo> get providerData => [];

  @override
  String? get phoneNumber => null;

  @override
  String? get photoURL => null;

  @override
  String? get refreshToken => null;

  @override
  String? get tenantId => null;

  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'mock-token';

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async =>
      MockIdTokenResult();

  @override
  Future<void> reload() async {}

  @override
  Future<User> linkWithCredential(AuthCredential credential) async => this;

  @override
  Future<ConfirmationResult> linkWithPhoneNumber(String phoneNumber,
          [RecaptchaVerifier? verifier]) async =>
      MockConfirmationResult();

  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async =>
      MockUserCredential();

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) async => [];

  @override
  Future<UserCredential> reauthenticateWithCredential(
          AuthCredential credential) async =>
      MockUserCredential();

  @override
  Future<UserCredential> reauthenticateWithProvider(
          AuthProvider provider) async =>
      MockUserCredential();

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  Future<User> unlink(String providerId) async => this;

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential phoneCredential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}

  @override
  MultiFactor get multiFactor => MockMultiFactor();
}

// Mock classes for User dependencies
class MockUserMetadata extends UserMetadata {
  @override
  DateTime? get creationTime => DateTime.now();

  @override
  DateTime? get lastSignInTime => DateTime.now();
}

class MockIdTokenResult extends IdTokenResult {
  @override
  Map<String, dynamic> get claims => {};

  @override
  String? get token => 'mock-token';

  @override
  DateTime? get authTime => DateTime.now();

  @override
  DateTime? get expirationTime => DateTime.now().add(const Duration(hours: 1));

  @override
  DateTime? get issuedAtTime => DateTime.now();

  @override
  String? get signInProvider => 'mock';

  @override
  String? get signInSecondFactor => null;
}

class MockConfirmationResult extends ConfirmationResult {
  @override
  String get verificationId => 'mock-verification-id';

  @override
  Future<UserCredential> confirm(String verificationCode) async =>
      MockUserCredential();
}

class MockUserCredential extends UserCredential {
  @override
  User? get user => null;

  @override
  AuthCredential? get credential => null;

  @override
  AdditionalUserInfo? get additionalUserInfo => null;
}

class MockMultiFactor extends MultiFactor {
  @override
  List<MultiFactorInfo> get enrolledFactors => [];

  @override
  Future<void> enroll(MultiFactorAssertion assertion, MultiFactorSession session) async {}

  @override
  Future<MultiFactorSession> getSession() async => MockMultiFactorSession();

  @override
  Future<void> unenroll({String? factorUid, MultiFactorInfo? multiFactorInfo}) async {}
}

class MockMultiFactorSession extends MultiFactorSession {}
