import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart'; // Pull-to-refresh package
import 'package:ionicons/ionicons.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List trendingTopics = [];
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    fetchTrendingTopics();
  }

  // ✅ Pehli baar trending topics fetch karega
  // 🔥 Function to generate latest Wikipedia API URL dynamically
  String getLatestWikiURL() {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}";
    return 'https://en.wikipedia.org/api/rest_v1/feed/featured/2025/04/07';
  }

  Future<void> fetchTrendingTopics() async {
    final response = await http.get(
      Uri.parse(getLatestWikiURL()),
    ); // ✅ Dynamic URL
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        trendingTopics =
            data['mostread']['articles']
                .map(
                  (article) => {
                    'title': article['title'],
                    'description': article['extract'],
                    'image':
                        article['thumbnail'] != null
                            ? article['thumbnail']['source']
                            : null,
                  },
                )
                .toList();
      });
    }
    _refreshController.refreshCompleted();
  }

  // ✅ Ab ye sirf shuffle karega jab refresh hoga
  Future<void> shuffleTrendingTopics() async {
    trendingTopics.shuffle();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: shuffleTrendingTopics, // ✅ Refresh pe sirf shuffle karega
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.black, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Trending Topics',
                          style: TextStyle(
                            fontFamily: 'boldfont',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) =>ExploreScreen()));
                      },
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'boldfont',
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: trendingTopics.length,
                  itemBuilder: (context, index) {
                    return _buildTrendingTile(context, trendingTopics[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Trending topics UI

  Widget _buildTrendingTile(BuildContext context, dynamic article) {
    final String? imageUrl = article['image'];

    Widget imageWidget;

    if (imageUrl != null && imageUrl.endsWith('.svg')) {
      imageWidget = SvgPicture.network(
        imageUrl,
        width: 60,
        height: 60,
        placeholderBuilder:
            (context) => CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Ionicons.globe_outline, size: 60);
        },
      );
    } else {
      imageWidget = Icon(Ionicons.globe_outline, size: 60);
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageWidget,
        ),
        title: Text(
          article['title'] ?? 'No Title',
          style: TextStyle(fontFamily: 'boldfont'),
        ),
        subtitle: Text(
          article['description'] ?? 'No description available.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ArticlePage(
                    title: article['title'],
                    description: article['description'],
                    imageUrl: article['image'],
                  ),
            ),
          );
        },
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  ArticlePage({required this.title, required this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontFamily: 'boldfont', color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null) // Agar image available hai toh dikhao
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'boldfont',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
