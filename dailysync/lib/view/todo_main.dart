// todo_main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'create_task.dart'; 
import 'manage_category.dart';

class TodoMain extends StatefulWidget {
  const TodoMain({super.key});

  @override
  State<TodoMain> createState() => _TodoMainState();
}

class _TodoMainState extends State<TodoMain> with SingleTickerProviderStateMixin {
  List<String> categories = ["All", "Home"];
  int categorySelectedIndex = 0;

  final List<Map<String, dynamic>> tasks = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 🟨 Sticky note task card widget (no Expanded inside - allows variable height)
  Widget taskCard(Map<String, dynamic> task, int index) {
    return GestureDetector(
      onTap: () async {
        final updatedTask = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTask(
              existingTask: task,
              index: index, categories: [],
            ),
          ),
        );

        if (updatedTask == null) return;

        if (updatedTask == "delete") {
          setState(() {
            tasks.removeAt(index);
          });
        } else {
          setState(() {
            tasks[index] = updatedTask;
          });
        }
      },
      child: Container(
        // let the masonry grid control width; card controls its own height
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: task["color"] ?? Colors.amber.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // important so it wraps content
          children: [
            Text(
              task["title"] ?? "Untitled",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Optional image block (if you store images in tasks)
            if (task["image"] != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                // adapt height as required (image might influence card height)
                height: 100,
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(task["image"]),
                ),
              ),

            // flexible description — no Expanded so card grows
            if ((task["description"] ?? "").toString().trim().isNotEmpty)
              Text(
                task["description"] ?? "",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                softWrap: true,
              ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task["date"] ?? "",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
                Checkbox(
                  value: task["completed"] ?? false,
                  onChanged: (val) {
                    setState(() {
                      task["completed"] = val!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🟩 Category Card
  Widget categoryCard(String name, int index) {
    bool isSelected = index == categorySelectedIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          categorySelectedIndex = index;
        });
      },
      child: Container(
        height: 35,
        width: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(15),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String month = DateFormat.MMMM().format(now);
    int year = now.year;

    // responsive column count
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 700 ? 3 : 2; // 2 on phones, 3 on wide screens

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'To-Do',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.black),
          ),
          const SizedBox(width: 10),
        ],
      ),

      // Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 20),
                      Icon(Icons.arrow_left, color: Colors.grey.shade900, size: 30),
                      Text(
                        "$month $year",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Icon(Icons.arrow_right, color: Colors.grey.shade900, size: 30),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            Row(
  children: [
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              categoryCard(categories[i], i),
              const SizedBox(width: 10),
            ],
          ],
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.dashboard_customize_rounded),
      onPressed: () async {
        // Navigate to ManageCategory screen and wait for updates
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageCategory(
              categories: categories,
              onUpdateCategories: (updatedList) {
                setState(() {
                  // ✅ Step 1: Update category list
                  categories = updatedList;

          // ✅ Step 2: Fix tasks with deleted categories
          for (var task in tasks) {
            if (!categories.contains(task["category"])) {
              task["category"] = "All"; // move it safely to 'All'
            }
          }

          // ✅ Step 3: Ensure selected index is valid
          if (categorySelectedIndex >= categories.length) {
            categorySelectedIndex = 0; // reset to 'All'
          }
        });
      },
    ),
  ),
);

      },
    ),
  ],
),


            const SizedBox(height: 20),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Tasks",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey.shade800,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // The magic: Masonry grid (staggered / Pinterest style)
            Expanded(
  child: Builder(
    builder: (context) {
      // ✅ Filtered tasks based on category
      final filteredTasks = categorySelectedIndex == 0
          ? tasks // “All”
          : tasks
              .where((task) => task["category"] == categories[categorySelectedIndex])
              .toList();

      if (filteredTasks.isEmpty) {
        return const Center(
          child: Text(
            "No tasks yet",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        );
      }

      return MasonryGridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return taskCard(filteredTasks[index], index);
        },
      );
    },
  ),
),

          ],
        ),
      ),

      // Floating Add Button
      floatingActionButton: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: FloatingActionButton(
              onPressed: () async {
  final newTask = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CreateTask(
        categories: categories, // ✅ send the category list
      ),
    ),
  );

  if (newTask != null && newTask is Map<String, dynamic>) {
    setState(() {
      tasks.add(newTask);
    });
  }
},

              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
