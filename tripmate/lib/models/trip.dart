import 'activity.dart';
import 'expense.dart';

class Trip {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> travelers;
  final List<Activity> activities;
  final List<Expense> expenses;
  final String? imageUrl;
  final String? description;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    required this.activities,
    required this.expenses,
    this.imageUrl,
    this.description,
  });

  // Factory constructor to create Trip from Firestore document
  factory Trip.fromMap(Map<String, dynamic> map, String documentId) {
    return Trip(
      id: documentId,
      title: map['title'] ?? '',
      destination: map['destination'] ?? '',
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] ?? 0),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] ?? 0),
      travelers: List<String>.from(map['travelers'] ?? []),
      activities: (map['activities'] as List<dynamic>?)
              ?.map((activity) => Activity.fromMap(activity))
              .toList() ??
          [],
      expenses: (map['expenses'] as List<dynamic>?)
              ?.map((expense) => Expense.fromMap(expense))
              .toList() ??
          [],
      imageUrl: map['imageUrl'],
      description: map['description'],
    );
  }

  // Convert Trip to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'destination': destination,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'travelers': travelers,
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'expenses': expenses.map((expense) => expense.toMap()).toList(),
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // Calculate total expenses
  double get totalExpenses {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get trip duration in days
  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  // Check if trip is upcoming
  bool get isUpcoming {
    return startDate.isAfter(DateTime.now());
  }

  // Check if trip is ongoing
  bool get isOngoing {
    final now = DateTime.now();
    return startDate.isBefore(now) && endDate.isAfter(now);
  }

  // Check if trip is completed
  bool get isCompleted {
    return endDate.isBefore(DateTime.now());
  }

  // Get trip status
  String get status {
    if (isUpcoming) return 'Upcoming';
    if (isOngoing) return 'Ongoing';
    return 'Completed';
  }

  // Copy with method for updating trip
  Trip copyWith({
    String? id,
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? travelers,
    List<Activity>? activities,
    List<Expense>? expenses,
    String? imageUrl,
    String? description,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      activities: activities ?? this.activities,
      expenses: expenses ?? this.expenses,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Trip{id: $id, title: $title, destination: $destination, startDate: $startDate, endDate: $endDate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
