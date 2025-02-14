import 'package:flutter/material.dart';

class MyCoursesPage extends StatelessWidget {
  final List<Map<String, String>> registeredCourses = [
    {'title': 'Using Android Studio', 'description': 'Learning how to use Android Studio'},
    {'title': 'Learning Guitar Chords','description': 'Learning how to play basic Guitar Chords'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Courses')),
      body: registeredCourses.isEmpty
          ? Center(child: Text('No courses registered'))
          : ListView.builder(
        itemCount: registeredCourses.length,
        itemBuilder: (context, index) {
          final course = registeredCourses[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(course['title']!),
              subtitle: Text(course['description']!),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to course details (if needed)
              },
            ),
          );
        },
      ),
    );
  }
}
