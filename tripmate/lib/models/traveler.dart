class Traveler {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? passportNumber;
  final DateTime? passportExpiry;
  final List<String> emergencyContacts;
  final Map<String, String> preferences;
  final bool isCurrentUser;

  Traveler({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.dateOfBirth,
    this.nationality,
    this.passportNumber,
    this.passportExpiry,
    this.emergencyContacts = const [],
    this.preferences = const {},
    this.isCurrentUser = false,
  });

  // Factory constructor to create Traveler from Map
  factory Traveler.fromMap(Map<String, dynamic> map) {
    return Traveler(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      profileImageUrl: map['profileImageUrl'],
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'])
          : null,
      nationality: map['nationality'],
      passportNumber: map['passportNumber'],
      passportExpiry: map['passportExpiry'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['passportExpiry'])
          : null,
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
      preferences: Map<String, String>.from(map['preferences'] ?? {}),
      isCurrentUser: map['isCurrentUser'] ?? false,
    );
  }

  // Convert Traveler to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': dateOfBirth?.millisecondsSinceEpoch,
      'nationality': nationality,
      'passportNumber': passportNumber,
      'passportExpiry': passportExpiry?.millisecondsSinceEpoch,
      'emergencyContacts': emergencyContacts,
      'preferences': preferences,
      'isCurrentUser': isCurrentUser,
    };
  }

  // Get traveler's age
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  // Get initials for profile display
  String get initials {
    final names = name.trim().split(' ');
    if (names.isEmpty) return '';
    if (names.length == 1) {
      return names[0].substring(0, 1).toUpperCase();
    }
    return '${names[0].substring(0, 1)}${names[names.length - 1].substring(0, 1)}'.toUpperCase();
  }

  // Check if passport is expiring soon (within 6 months)
  bool get isPassportExpiringSoon {
    if (passportExpiry == null) return false;
    final sixMonthsFromNow = DateTime.now().add(const Duration(days: 180));
    return passportExpiry!.isBefore(sixMonthsFromNow);
  }

  // Check if passport is expired
  bool get isPassportExpired {
    if (passportExpiry == null) return false;
    return passportExpiry!.isBefore(DateTime.now());
  }

  // Get formatted passport expiry status
  String get passportStatus {
    if (passportExpiry == null) return 'No passport info';
    if (isPassportExpired) return 'Expired';
    if (isPassportExpiringSoon) return 'Expiring soon';
    return 'Valid';
  }

  // Get dietary preferences
  String? get dietaryPreferences {
    return preferences['dietary'];
  }

  // Get accommodation preferences
  String? get accommodationPreferences {
    return preferences['accommodation'];
  }

  // Get activity preferences
  String? get activityPreferences {
    return preferences['activities'];
  }

  // Get budget preferences
  String? get budgetPreferences {
    return preferences['budget'];
  }

  // Check if traveler has complete profile
  bool get hasCompleteProfile {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber != null &&
        dateOfBirth != null &&
        nationality != null;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 6;

    if (name.isNotEmpty) completedFields++;
    if (email.isNotEmpty) completedFields++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) completedFields++;
    if (dateOfBirth != null) completedFields++;
    if (nationality != null && nationality!.isNotEmpty) completedFields++;
    if (passportNumber != null && passportNumber!.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  // Copy with method for updating traveler
  Traveler copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? nationality,
    String? passportNumber,
    DateTime? passportExpiry,
    List<String>? emergencyContacts,
    Map<String, String>? preferences,
    bool? isCurrentUser,
  }) {
    return Traveler(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      passportNumber: passportNumber ?? this.passportNumber,
      passportExpiry: passportExpiry ?? this.passportExpiry,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      preferences: preferences ?? this.preferences,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  @override
  String toString() {
    return 'Traveler{id: $id, name: $name, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Traveler && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Travel preferences constants
class TravelPreferences {
  // Dietary preferences
  static const String vegetarian = 'Vegetarian';
  static const String vegan = 'Vegan';
  static const String glutenFree = 'Gluten-free';
  static const String halal = 'Halal';
  static const String kosher = 'Kosher';
  static const String noDietaryRestrictions = 'No restrictions';

  static List<String> get dietaryOptions => [
        vegetarian,
        vegan,
        glutenFree,
        halal,
        kosher,
        noDietaryRestrictions,
      ];

  // Accommodation preferences
  static const String hotel = 'Hotel';
  static const String hostel = 'Hostel';
  static const String airbnb = 'Airbnb';
  static const String resort = 'Resort';
  static const String camping = 'Camping';

  static List<String> get accommodationOptions => [
        hotel,
        hostel,
        airbnb,
        resort,
        camping,
      ];

  // Activity preferences
  static const String adventure = 'Adventure';
  static const String cultural = 'Cultural';
  static const String relaxation = 'Relaxation';
  static const String nightlife = 'Nightlife';
  static const String nature = 'Nature';
  static const String shopping = 'Shopping';

  static List<String> get activityOptions => [
        adventure,
        cultural,
        relaxation,
        nightlife,
        nature,
        shopping,
      ];

  // Budget preferences
  static const String budget = 'Budget';
  static const String midRange = 'Mid-range';
  static const String luxury = 'Luxury';

  static List<String> get budgetOptions => [
        budget,
        midRange,
        luxury,
      ];
}
