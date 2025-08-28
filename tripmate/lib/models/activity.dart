class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String location;
  final double? latitude;
  final double? longitude;
  final String category;
  final double? estimatedCost;
  final int durationMinutes;
  final bool isCompleted;
  final String? imageUrl;
  final List<String> tags;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.location,
    this.latitude,
    this.longitude,
    required this.category,
    this.estimatedCost,
    required this.durationMinutes,
    this.isCompleted = false,
    this.imageUrl,
    this.tags = const [],
  });

  // Factory constructor to create Activity from Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] ?? 0),
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      category: map['category'] ?? 'General',
      estimatedCost: map['estimatedCost']?.toDouble(),
      durationMinutes: map['durationMinutes'] ?? 60,
      isCompleted: map['isCompleted'] ?? false,
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  // Convert Activity to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
      'estimatedCost': estimatedCost,
      'durationMinutes': durationMinutes,
      'isCompleted': isCompleted,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }

  // Get formatted duration
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}m';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}m';
      }
    }
  }

  // Check if activity has location coordinates
  bool get hasCoordinates {
    return latitude != null && longitude != null;
  }

  // Get activity category icon (text-based since no icon libraries)
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'food':
        return '🍽️';
      case 'sightseeing':
        return '🏛️';
      case 'adventure':
        return '🏔️';
      case 'shopping':
        return '🛍️';
      case 'entertainment':
        return '🎭';
      case 'transport':
        return '🚗';
      case 'accommodation':
        return '🏨';
      default:
        return '📍';
    }
  }

  // Copy with method for updating activity
  Activity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    double? latitude,
    double? longitude,
    String? category,
    double? estimatedCost,
    int? durationMinutes,
    bool? isCompleted,
    String? imageUrl,
    List<String>? tags,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'Activity{id: $id, title: $title, location: $location, dateTime: $dateTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Activity categories enum for consistency
class ActivityCategory {
  static const String food = 'Food';
  static const String sightseeing = 'Sightseeing';
  static const String adventure = 'Adventure';
  static const String shopping = 'Shopping';
  static const String entertainment = 'Entertainment';
  static const String transport = 'Transport';
  static const String accommodation = 'Accommodation';
  static const String general = 'General';

  static List<String> get all => [
        food,
        sightseeing,
        adventure,
        shopping,
        entertainment,
        transport,
        accommodation,
        general,
      ];
}
