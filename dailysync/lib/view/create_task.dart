import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTask extends StatefulWidget {
  final Map<String, dynamic>? existingTask;
  final int? index;
  final List<String> categories; // ✅ receive list of categories

  const CreateTask({
    super.key,
    this.existingTask,
    this.index,
    required this.categories,
  });

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      titleController.text = widget.existingTask!["title"];
      descController.text = widget.existingTask!["description"];
      selectedCategory = widget.existingTask!["category"];
    } else {
      // Default to first category except “All”
      selectedCategory = widget.categories.length > 1 ? widget.categories[1] : "All";
    }
  }

  void saveTask() {
    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task title")),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
      return;
    }

    final String now = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final Map<String, dynamic> newTask = {
      "title": titleController.text.trim(),
      "description": descController.text.trim(),
      "completed": widget.existingTask?["completed"] ?? false,
      "date": now,
      "category": selectedCategory, // ✅ store category
      "color": widget.existingTask?["color"] ??
          Colors.primaries[DateTime.now().millisecond % Colors.primaries.length].shade100,
    };

    Navigator.pop(context, newTask);
  }

  void deleteTask() {
    Navigator.pop(context, "delete");
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingTask != null;

    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade100,
        elevation: 0,
        title: Text(
          isEditing ? "Edit Task" : "New Task",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: deleteTask,
            ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.grey),
            onPressed: saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // 🟩 Category Dropdown
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: "Select Category",
                border: OutlineInputBorder(),
              ),
              items: widget.categories
                  .where((cat) => cat != "All") // prevent selecting “All”
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: descController,
                decoration: const InputDecoration(
                  hintText: "Note here",
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
