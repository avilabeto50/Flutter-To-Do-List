import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/screens/home.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskTitleController = TextEditingController();

  void _addTask() {
    // Create a new Task object
    Task newTask = Task(
      title: _taskTitleController.text,
      isCompleted: false,  // Assuming the task is initially not completed
    );

    // Add the task to Firestore
    FirebaseFirestore.instance.collection('tasks').add(newTask.toMap());

    // You can navigate back to the previous screen or perform other actions
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addTask,
              child: Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
