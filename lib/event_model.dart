class Event {
  final String title;
  final String? imageUrl;
  final String date;
  final String venue;

  Event({
    required this.title,
    this.imageUrl,
    required this.date,
    required this.venue,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['name'] ?? 'No Title',
      imageUrl: json['_embedded']?['venues']?[0]?['images']?[0]?['url'],
      date: json['dates']?['start']?['localDate'] ?? 'No Date',
      venue: json['_embedded']?['venues']?[0]?['name'] ?? 'No Venue',
    );
  }
}
