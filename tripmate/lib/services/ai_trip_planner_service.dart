import 'dart:math';
import '../models/activity.dart';
import '../models/trip.dart';

class AiTripPlannerService {
  static final Random _random = Random();

  // Mock AI trip planning
  static Future<List<Activity>> generateTripItinerary({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> interests,
    required String budgetLevel,
    required int numberOfTravelers,
  }) async {
    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 3));

    try {
      List<Activity> activities = [];
      int tripDuration = endDate.difference(startDate).inDays + 1;

      // Generate activities based on destination and interests
      List<ActivityTemplate> templates = _getActivityTemplates(destination, interests);
      
      for (int day = 0; day < tripDuration; day++) {
        DateTime currentDate = startDate.add(Duration(days: day));
        
        // Generate 2-4 activities per day
        int activitiesPerDay = 2 + _random.nextInt(3);
        
        for (int i = 0; i < activitiesPerDay; i++) {
          ActivityTemplate template = templates[_random.nextInt(templates.length)];
          
          Activity activity = Activity(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}_${day}_$i',
            title: template.title,
            description: template.description,
            dateTime: currentDate.add(Duration(
              hours: 9 + (i * 3), // Spread activities throughout the day
              minutes: _random.nextInt(60),
            )),
            location: template.location,
            latitude: template.latitude,
            longitude: template.longitude,
            category: template.category,
            estimatedCost: _calculateCostByBudget(template.baseCost, budgetLevel),
            durationMinutes: template.durationMinutes,
            tags: template.tags,
          );
          
          activities.add(activity);
        }
      }

      // Sort activities by date and time
      activities.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      
      return activities;
    } catch (e) {
      throw Exception('Failed to generate trip itinerary: ${e.toString()}');
    }
  }

  // Get activity templates based on destination and interests
  static List<ActivityTemplate> _getActivityTemplates(String destination, List<String> interests) {
    List<ActivityTemplate> templates = [];

    // Add destination-specific templates
    templates.addAll(_getDestinationTemplates(destination));
    
    // Add interest-based templates
    for (String interest in interests) {
      templates.addAll(_getInterestTemplates(interest));
    }

    // Add general templates if not enough specific ones
    if (templates.length < 10) {
      templates.addAll(_getGeneralTemplates());
    }

    return templates;
  }

  // Get destination-specific activity templates
  static List<ActivityTemplate> _getDestinationTemplates(String destination) {
    String lowerDestination = destination.toLowerCase();
    
    if (lowerDestination.contains('paris')) {
      return [
        ActivityTemplate(
          title: 'Visit the Eiffel Tower',
          description: 'Iconic iron lattice tower and symbol of Paris',
          location: 'Champ de Mars, Paris',
          latitude: 48.8584,
          longitude: 2.2945,
          category: ActivityCategory.sightseeing,
          baseCost: 25.0,
          durationMinutes: 120,
          tags: ['iconic', 'photography', 'landmark'],
        ),
        ActivityTemplate(
          title: 'Louvre Museum Tour',
          description: 'World\'s largest art museum and historic monument',
          location: 'Rue de Rivoli, Paris',
          latitude: 48.8606,
          longitude: 2.3376,
          category: ActivityCategory.sightseeing,
          baseCost: 17.0,
          durationMinutes: 180,
          tags: ['art', 'culture', 'museum'],
        ),
        ActivityTemplate(
          title: 'Seine River Cruise',
          description: 'Scenic boat tour along the Seine River',
          location: 'Port de la Bourdonnais, Paris',
          latitude: 48.8606,
          longitude: 2.2945,
          category: ActivityCategory.entertainment,
          baseCost: 15.0,
          durationMinutes: 90,
          tags: ['scenic', 'relaxing', 'river'],
        ),
      ];
    } else if (lowerDestination.contains('tokyo')) {
      return [
        ActivityTemplate(
          title: 'Senso-ji Temple Visit',
          description: 'Ancient Buddhist temple in Asakusa district',
          location: 'Asakusa, Tokyo',
          latitude: 35.7148,
          longitude: 139.7967,
          category: ActivityCategory.sightseeing,
          baseCost: 0.0,
          durationMinutes: 90,
          tags: ['temple', 'culture', 'traditional'],
        ),
        ActivityTemplate(
          title: 'Shibuya Crossing Experience',
          description: 'World\'s busiest pedestrian crossing',
          location: 'Shibuya, Tokyo',
          latitude: 35.6598,
          longitude: 139.7006,
          category: ActivityCategory.sightseeing,
          baseCost: 0.0,
          durationMinutes: 60,
          tags: ['urban', 'iconic', 'photography'],
        ),
        ActivityTemplate(
          title: 'Tsukiji Fish Market Tour',
          description: 'Famous fish market and sushi breakfast',
          location: 'Tsukiji, Tokyo',
          latitude: 35.6654,
          longitude: 139.7707,
          category: ActivityCategory.food,
          baseCost: 30.0,
          durationMinutes: 120,
          tags: ['food', 'market', 'sushi'],
        ),
      ];
    } else {
      return _getGeneralTemplates();
    }
  }

  // Get interest-based activity templates
  static List<ActivityTemplate> _getInterestTemplates(String interest) {
    switch (interest.toLowerCase()) {
      case 'food':
        return [
          ActivityTemplate(
            title: 'Local Food Tour',
            description: 'Guided tour of local cuisine and specialties',
            location: 'City Center',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.food,
            baseCost: 45.0,
            durationMinutes: 180,
            tags: ['food', 'local', 'guided'],
          ),
          ActivityTemplate(
            title: 'Cooking Class',
            description: 'Learn to cook traditional local dishes',
            location: 'Cooking School',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.food,
            baseCost: 60.0,
            durationMinutes: 150,
            tags: ['cooking', 'hands-on', 'learning'],
          ),
        ];
      case 'adventure':
        return [
          ActivityTemplate(
            title: 'Hiking Trail',
            description: 'Scenic hiking trail with beautiful views',
            location: 'National Park',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.adventure,
            baseCost: 15.0,
            durationMinutes: 240,
            tags: ['hiking', 'nature', 'exercise'],
          ),
          ActivityTemplate(
            title: 'Rock Climbing',
            description: 'Guided rock climbing experience',
            location: 'Climbing Center',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.adventure,
            baseCost: 80.0,
            durationMinutes: 180,
            tags: ['climbing', 'adventure', 'guided'],
          ),
        ];
      case 'culture':
        return [
          ActivityTemplate(
            title: 'Museum Visit',
            description: 'Explore local history and culture',
            location: 'City Museum',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.sightseeing,
            baseCost: 12.0,
            durationMinutes: 120,
            tags: ['museum', 'culture', 'history'],
          ),
          ActivityTemplate(
            title: 'Cultural Performance',
            description: 'Traditional music and dance performance',
            location: 'Cultural Center',
            latitude: 0.0,
            longitude: 0.0,
            category: ActivityCategory.entertainment,
            baseCost: 25.0,
            durationMinutes: 90,
            tags: ['performance', 'traditional', 'culture'],
          ),
        ];
      default:
        return [];
    }
  }

  // Get general activity templates
  static List<ActivityTemplate> _getGeneralTemplates() {
    return [
      ActivityTemplate(
        title: 'City Walking Tour',
        description: 'Guided walking tour of the city highlights',
        location: 'City Center',
        latitude: 0.0,
        longitude: 0.0,
        category: ActivityCategory.sightseeing,
        baseCost: 20.0,
        durationMinutes: 150,
        tags: ['walking', 'guided', 'overview'],
      ),
      ActivityTemplate(
        title: 'Local Market Visit',
        description: 'Explore local markets and shops',
        location: 'Central Market',
        latitude: 0.0,
        longitude: 0.0,
        category: ActivityCategory.shopping,
        baseCost: 10.0,
        durationMinutes: 90,
        tags: ['market', 'shopping', 'local'],
      ),
      ActivityTemplate(
        title: 'Park Relaxation',
        description: 'Peaceful time in a beautiful local park',
        location: 'City Park',
        latitude: 0.0,
        longitude: 0.0,
        category: ActivityCategory.general,
        baseCost: 0.0,
        durationMinutes: 60,
        tags: ['park', 'relaxing', 'nature'],
      ),
    ];
  }

  // Calculate cost based on budget level
  static double _calculateCostByBudget(double baseCost, String budgetLevel) {
    switch (budgetLevel.toLowerCase()) {
      case 'budget':
        return baseCost * 0.7;
      case 'luxury':
        return baseCost * 1.5;
      default: // mid-range
        return baseCost;
    }
  }

  // Generate trip suggestions based on preferences
  static Future<List<TripSuggestion>> getTripSuggestions({
    required List<String> interests,
    required String budgetLevel,
    required int durationDays,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    List<TripSuggestion> suggestions = [
      TripSuggestion(
        destination: 'Paris, France',
        title: 'Romantic Paris Getaway',
        description: 'Experience the city of love with iconic landmarks, world-class cuisine, and charming neighborhoods.',
        estimatedCost: _calculateTripCost(durationDays, budgetLevel, 1200),
        imageUrl: 'https://placehold.co/400x300?text=Paris+Eiffel+Tower+romantic+cityscape',
        highlights: ['Eiffel Tower', 'Louvre Museum', 'Seine River Cruise', 'Montmartre'],
        bestTimeToVisit: 'April - June, September - October',
      ),
      TripSuggestion(
        destination: 'Tokyo, Japan',
        title: 'Modern Tokyo Adventure',
        description: 'Discover the perfect blend of traditional culture and cutting-edge technology in Japan\'s capital.',
        estimatedCost: _calculateTripCost(durationDays, budgetLevel, 1400),
        imageUrl: 'https://placehold.co/400x300?text=Tokyo+skyline+modern+city+neon+lights',
        highlights: ['Shibuya Crossing', 'Senso-ji Temple', 'Tsukiji Market', 'Mount Fuji Day Trip'],
        bestTimeToVisit: 'March - May, September - November',
      ),
      TripSuggestion(
        destination: 'Bali, Indonesia',
        title: 'Tropical Paradise Escape',
        description: 'Relax on beautiful beaches, explore ancient temples, and enjoy the vibrant local culture.',
        estimatedCost: _calculateTripCost(durationDays, budgetLevel, 800),
        imageUrl: 'https://placehold.co/400x300?text=Bali+tropical+beach+palm+trees+sunset',
        highlights: ['Ubud Rice Terraces', 'Tanah Lot Temple', 'Seminyak Beach', 'Traditional Spa'],
        bestTimeToVisit: 'April - October',
      ),
    ];

    return suggestions;
  }

  static double _calculateTripCost(int days, String budgetLevel, double baseCost) {
    double cost = baseCost * (days / 7.0); // Base cost for 7 days
    
    switch (budgetLevel.toLowerCase()) {
      case 'budget':
        return cost * 0.6;
      case 'luxury':
        return cost * 2.0;
      default:
        return cost;
    }
  }
}

// Activity template for AI generation
class ActivityTemplate {
  final String title;
  final String description;
  final String location;
  final double latitude;
  final double longitude;
  final String category;
  final double baseCost;
  final int durationMinutes;
  final List<String> tags;

  ActivityTemplate({
    required this.title,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.baseCost,
    required this.durationMinutes,
    required this.tags,
  });
}

// Trip suggestion model
class TripSuggestion {
  final String destination;
  final String title;
  final String description;
  final double estimatedCost;
  final String imageUrl;
  final List<String> highlights;
  final String bestTimeToVisit;

  TripSuggestion({
    required this.destination,
    required this.title,
    required this.description,
    required this.estimatedCost,
    required this.imageUrl,
    required this.highlights,
    required this.bestTimeToVisit,
  });
}
