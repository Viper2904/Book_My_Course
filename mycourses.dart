import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCoursesPage extends StatefulWidget {
  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  List<Map<String, dynamic>> _registeredCourses = [];
  bool _isLoading = true;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/v1/courses/all"), // Use 10.0.2.2 for Android Emulator
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _registeredCourses = List<Map<String, dynamic>>.from(responseData["data"]);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch courses. Status Code: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "Something went wrong. Error: $error";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Courses')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
          : _registeredCourses.isEmpty
          ? Center(child: Text('No courses registered'))
          : RefreshIndicator(
        onRefresh: _fetchCourses,
        child: ListView.builder(
          itemCount: _registeredCourses.length,
          itemBuilder: (context, index) {
            final course = _registeredCourses[index];
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(course['title']),
                subtitle: Text(course['description']),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/courseDetails",
                    arguments: course["id"],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

