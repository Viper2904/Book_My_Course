import 'package:flutter/material.dart';
import 'videop.dart'; // Import the video player widget

// Course Model
class Course {
  String title;
  String description;
  String imageUrl;
  String videoUrl; // Added a video URL field

  Course({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
  });
}

// Course List Page
class CoursePage extends StatelessWidget {
  CoursePage({Key? key}) : super(key: key);

  final List<Course> courses = [
    Course(
      title: "Using Android Studio",
      description: "Learning how to use Android Studio",
      imageUrl: 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0ZuKYaO5BKYi1kmED6V0-AWptdDduxN2D8vJ2b12aTONID2m3DYLjVcqfESjEzRtbT0sZRKpbL5Znyk9z4Ldx_AI6GKjIsyjTwpThE1hPaq5_zxOoYa_rLHDagW-HCwJZR4tIF5W_evscw0bw3hbwCJ_7_GHdzGS-EwyoLbgIB8ezLrlkJCynIg6M/s1600/image29.png',
      videoUrl: "videos/v1.mp4",
    ),
    Course(
      title: "Example",
      description: "Example",
      imageUrl: 'https://www.shutterstock.com/blog/wp-content/uploads/sites/5/2022/02/logo_examples_cover.jpg?w=1250&h=1120&crop=1',
      videoUrl: "videos/v1.mp4",
    ),
    Course(
      title: "Learning Guitar Chords",
      description: "Learning how to play basic Guitar Chords",
      imageUrl: 'https://t3.ftcdn.net/jpg/09/23/24/42/360_F_923244242_IGyLU4oL7utmu8yOi78wYfHBtN0w16eg.jpg',
      videoUrl: "videos/v1.mp4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) => CourseTile(course: courses[index]),
      ),
    );
  }
}

// Course Tile Widget
class CourseTile extends StatelessWidget {
  final Course course;
  const CourseTile({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(course.imageUrl, width: 80, fit: BoxFit.cover),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(course.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CourseDetailPage(course: course)),
        ),
      ),
    );
  }
}

// Course Detail Page with Video Player
class CourseDetailPage extends StatelessWidget {
  final Course course;
  const CourseDetailPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(course.imageUrl, width: double.infinity, height: 200, fit: BoxFit.fitWidth),
              const SizedBox(height: 16),
              Text(course.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(course.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              // Integrating the Video Player
              VideoPlayerWidget(videoUrl: course.videoUrl),
            ],
          ),
        ),
      ),
    );
  }
}
