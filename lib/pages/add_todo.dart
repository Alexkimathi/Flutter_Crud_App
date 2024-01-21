import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;

    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData :submitData,
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                isEdit ? 'Update' : 'Submit'),
          ))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if(todo == null){
      print ('you cannot update');
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,

    };
    // Submit
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    // Convert the 'body' map to a JSON-encoded string
    final encodedBody = jsonEncode(body);

    // Use 'http.post' with the correct parameters
    final response = await http.put(
      uri,
      body: encodedBody,
      headers: {'Content-Type': 'application/json'},
    );
    // Show success
    if (response.statusCode == 200) {
      showSuccessMessage('updated successfully');
    } else {
      showErrorMessage('updating failed');
    }

  }

  Future<void> submitData() async {
    // Get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // Submit
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    // Convert the 'body' map to a JSON-encoded string
    final encodedBody = jsonEncode(body);

    // Use 'http.post' with the correct parameters
    final response = await http.post(
      uri,
      body: encodedBody,
      headers: {'Content-Type': 'application/json'},
    );

    // Show success
    if (response.statusCode == 201) {
      titleController.text ='';
      descriptionController.text='';
      showSuccessMessage('Created successfully');
    } else {
      showErrorMessage('failed');
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
