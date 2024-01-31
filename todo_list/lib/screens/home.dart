import 'package:flutter/material.dart';
import 'package:todo_list/screens/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              // Convert Firestore data to Task object
              Task task = Task(
                title: documents[index]['title'],
                isCompleted: documents[index]['isCompleted'],
              );

              return ListTile(
                title: Text(task.title),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    // Update the task's completion status in Firestore
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(documents[index].id)
                        .update({
                      'isCompleted': value,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddTaskScreen when the FloatingActionButton is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  final String title;
  final bool isCompleted;

  Task({
    required this.title,
    required this.isCompleted,
  });

  // Convert a Task object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
