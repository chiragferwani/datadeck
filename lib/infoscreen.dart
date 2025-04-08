import 'package:flutter/material.dart';

class ProjectInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Project Info', style: TextStyle(fontFamily: 'boldfont')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Apne project ka logo yaha dal
              height: 200,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'DataDesk',
            style: TextStyle(fontSize: 24, fontFamily: 'boldfont'),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'This app serves as an all-in-one platform where users can explore summarized articles, discover and save movies, and personalize their experience by uploading a profile photo and entering personal details. It fetches real-time data from trusted sources like Wikipedia and TMDB, ensuring updated and relevant content. With a simple interface and smooth performance, the app delivers both information and entertainment. 🚀',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
            ),
          ),
          SizedBox(height: 15),

          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'V 1.0.0',
              style: TextStyle(fontSize: 16, fontFamily: 'boldfont'),
            ),
          ),
        ],
      ),
    );
  }
}
