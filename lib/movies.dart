import 'dart:convert';
import 'package:datadeck/saved_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ionicons/ionicons.dart';

class MoviesScreen extends StatefulWidget {
  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final TextEditingController searchController = TextEditingController();
  final SavedController savedController = Get.put(SavedController());

  List movies = [];
  bool isLoading = false;

  final String apiKey =
      'YOUR_API_KEY'; // Replace with your TMDB API key

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
  }

  Future<void> fetchTrendingMovies() async {
    setState(() => isLoading = true);

    final url =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        movies = result['results'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to load movies');
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return fetchTrendingMovies();

    setState(() => isLoading = true);

    final url =
        'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        movies = result['results'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                onChanged: searchMovies,
                style: TextStyle(color: Colors.black, fontFamily: 'boldfont'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: 'Search Movies',
                  hintStyle: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'boldfont',
                  ),
                  prefixIcon: Icon(Ionicons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Movies List
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : Expanded(
                  child: ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      final imageUrl =
                          'https://image.tmdb.org/t/p/w500${movie['poster_path']}';
                      final title = movie['title'] ?? 'No Title';
                      final rating = (movie['vote_average'] / 2)
                          .toStringAsFixed(1);
                      final isSaved = savedController.isSaved({
                        'id': movie['id'],
                      });

                      final movieData = {
                        'id': movie['id'],
                        'title': title,
                        'imageUrl': imageUrl,
                        'rating': rating,
                        'type': 'movie',
                      };

                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading:
                              movie['poster_path'] != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Icon(Ionicons.videocam_outline, size: 60),

                          title: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'boldfont',
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            'Rating: $rating/5',
                            style: TextStyle(fontFamily: 'boldfont'),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              color: Colors.black,
                            ),
                            onPressed:
                                () => savedController.toggleSave(movieData),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
