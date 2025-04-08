import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];
  List<dynamic> _savedEvents = [];
  bool _showSaved = false;

  // Yaha daal apna Ticketmaster API key
  final String _apiKey = 'GNOSzt8ghqrLcSNp';

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final uri = Uri.parse(
      'https://app.ticketmaster.com/discovery/v2/events.json?apikey=$_apiKey&countryCode=IN&size=20',
    );
    try {
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List eventsJson = data['_embedded']?['events'] ?? [];
        setState(() {
          _events = eventsJson;
        });
      } else {
        print("Event fetch fail ho gaya bro: ${res.body}");
      }
    } catch (e) {
      print("Exception aayi bro: $e");
    }
  }

  void toggleSave(event) {
    setState(() {
      if (_savedEvents.contains(event)) {
        _savedEvents.remove(event);
      } else {
        _savedEvents.add(event);
      }
    });
  }

  bool isSaved(event) {
    return _savedEvents.contains(event);
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _showSaved ? _savedEvents : _events;

    return Scaffold(
      appBar: AppBar(
        title: Text(_showSaved ? 'Saved Events' : 'Events'),
        actions: [
          IconButton(
            icon: Icon(_showSaved ? Icons.grid_view : Icons.bookmark),
            onPressed: () {
              setState(() {
                _showSaved = !_showSaved;
              });
            },
          ),
        ],
      ),
      body:
          currentList.isEmpty
              ? Center(
                child: Text(
                  _showSaved
                      ? "Bro kuch bhi save nahi kiya"
                      : "Loading ya koi error hai...",
                ),
              )
              : GridView.builder(
                padding: EdgeInsets.all(12),
                itemCount: currentList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards in a row
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final event = currentList[index];
                  final imageUrl = event['images']?[0]?['url'];
                  final title = event['name'] ?? 'No Title';
                  final date =
                      event['dates']?['start']?['localDate'] ?? 'No Date';
                  final venue =
                      event['_embedded']?['venues']?[0]?['name'] ?? 'No Venue';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageUrl != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.network(
                                imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Container(height: 120, color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(date),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(venue, style: TextStyle(fontSize: 12)),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              isSaved(event)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.blue,
                            ),
                            onPressed: () => toggleSave(event),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
