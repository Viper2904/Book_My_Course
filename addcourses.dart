import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateNewCourse extends StatefulWidget {
  @override
  _CreateNewCourseState createState() => _CreateNewCourseState();
}

class _CreateNewCourseState extends State<CreateNewCourse> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? accessToken = "YOUR_ACCESS_TOKEN"; // Replace this with actual token handling

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;

    if (accessToken == null || accessToken!.isEmpty) {
      _showMessage("Please login or create an account to continue");
      Navigator.pushReplacementNamed(context, "/login");
      return;
    }

    final url = Uri.parse("http://127.0.0.1:8000/api/v1/course/initializeCourse");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final body = jsonEncode({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': _priceController.text.trim(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData.containsKey('message')) {
        _showMessage("Course created successfully");
        Navigator.pushNamed(context, "/course/edit/${responseData['message']['_id']}");
      } else {
        _showMessage("Failed to create course");
      }
    } catch (error) {
      _showMessage("Error creating course. Please try again.");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Set up your course")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Course title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.trim().isEmpty ? "Enter a title" : null,
              ),
              SizedBox(height: 10),
              Text("Description:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Course description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.trim().isEmpty ? "Enter a description" : null,
              ),
              SizedBox(height: 10),
              Text("Price:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.trim().isEmpty ? "Enter a price" : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _createCourse,
                  child: Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

