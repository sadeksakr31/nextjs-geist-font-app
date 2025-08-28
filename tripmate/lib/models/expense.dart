class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String currency;
  final String category;
  final DateTime dateTime;
  final String paidBy;
  final List<String> sharedWith;
  final String? receiptImageUrl;
  final String? location;
  final bool isShared;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    this.currency = 'USD',
    required this.category,
    required this.dateTime,
    required this.paidBy,
    this.sharedWith = const [],
    this.receiptImageUrl,
    this.location,
    this.isShared = false,
  });

  // Factory constructor to create Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'USD',
      category: map['category'] ?? 'General',
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] ?? 0),
      paidBy: map['paidBy'] ?? '',
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      receiptImageUrl: map['receiptImageUrl'],
      location: map['location'],
      isShared: map['isShared'] ?? false,
    );
  }

  // Convert Expense to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'currency': currency,
      'category': category,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'paidBy': paidBy,
      'sharedWith': sharedWith,
      'receiptImageUrl': receiptImageUrl,
      'location': location,
      'isShared': isShared,
    };
  }

  // Get formatted amount with currency
  String get formattedAmount {
    return '${getCurrencySymbol(currency)}${amount.toStringAsFixed(2)}';
  }

  // Get currency symbol
  static String getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      default:
        return currency;
    }
  }

  // Calculate amount per person if shared
  double get amountPerPerson {
    if (!isShared || sharedWith.isEmpty) {
      return amount;
    }
    return amount / (sharedWith.length + 1); // +1 for the person who paid
  }

  // Get expense category icon (text-based since no icon libraries)
  String get categoryIcon {
    switch (category.toLowerCase()) {
      case 'food':
        return '🍽️';
      case 'transport':
        return '🚗';
      case 'accommodation':
        return '🏨';
      case 'entertainment':
        return '🎭';
      case 'shopping':
        return '🛍️';
      case 'sightseeing':
        return '🏛️';
      case 'health':
        return '🏥';
      case 'miscellaneous':
        return '📦';
      default:
        return '💰';
    }
  }

  // Get formatted shared info
  String get sharedInfo {
    if (!isShared || sharedWith.isEmpty) {
      return 'Paid by $paidBy';
    }
    return 'Shared with ${sharedWith.length} ${sharedWith.length == 1 ? 'person' : 'people'}';
  }

  // Copy with method for updating expense
  Expense copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    String? currency,
    String? category,
    DateTime? dateTime,
    String? paidBy,
    List<String>? sharedWith,
    String? receiptImageUrl,
    String? location,
    bool? isShared,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      dateTime: dateTime ?? this.dateTime,
      paidBy: paidBy ?? this.paidBy,
      sharedWith: sharedWith ?? this.sharedWith,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      location: location ?? this.location,
      isShared: isShared ?? this.isShared,
    );
  }

  @override
  String toString() {
    return 'Expense{id: $id, title: $title, amount: $amount, category: $category}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Expense categories for consistency
class ExpenseCategory {
  static const String food = 'Food';
  static const String transport = 'Transport';
  static const String accommodation = 'Accommodation';
  static const String entertainment = 'Entertainment';
  static const String shopping = 'Shopping';
  static const String sightseeing = 'Sightseeing';
  static const String health = 'Health';
  static const String miscellaneous = 'Miscellaneous';

  static List<String> get all => [
        food,
        transport,
        accommodation,
        entertainment,
        shopping,
        sightseeing,
        health,
        miscellaneous,
      ];
}

// Common currencies
class Currency {
  static const String usd = 'USD';
  static const String eur = 'EUR';
  static const String gbp = 'GBP';
  static const String jpy = 'JPY';
  static const String cad = 'CAD';
  static const String aud = 'AUD';

  static List<String> get all => [
        usd,
        eur,
        gbp,
        jpy,
        cad,
        aud,
      ];
}
