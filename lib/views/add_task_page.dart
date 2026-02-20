import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/utils/show_snackbar.dart';
import 'package:planit/models/task_model.dart';

import 'package:planit/viewmodels/task_viewmodel.dart';
import 'package:planit/views/widgets/category_selector.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final Uuid uuid = Uuid();
  late TextEditingController titleController;
  late TextEditingController descController;

  String selectedOption = "Today";
  DateTime? customDate;
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  //calender picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        customDate = picked;
        selectedDate = picked;
        selectedOption = "Custom";
      });
    }
  }

  void _setToday() {
    setState(() {
      selectedOption = "Today";
      if (customDate == null) {
        selectedDate = DateTime.now();
      }
    });
  }

  void _setTomorrow() {
    setState(() {
      selectedOption = "Tomorrow";
      if (customDate == null) {
        selectedDate = DateTime.now().add(Duration(days: 1));
      }
    });
  }

  void _showErrorSnackBar(String message) {
    showSnackBar(context, message, SnackBarType.error);
  }

  void _handleCreateTask() async {
    // Validation
    if (titleController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter a task title");
      return;
    }

    if (selectedCategory == null) {
      _showErrorSnackBar("Please select a category");
      return;
    }

    // Create Task object
    final task = Task(
      id: uuid.v4(),
      userId: "",
      title: titleController.text.trim(),
      description: descController.text.trim().isEmpty
          ? null
          : descController.text.trim(),
      category: selectedCategory!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueAt: selectedDate,
    );

    // Call viewmodel
    await ref.read(taskViewModelProvider.notifier).createTodo(task);

    // Handle result
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      fixedSize: Size(44, 44),

                      side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    onPressed: _pickDate,
                    icon: Icon(Icons.add),
                  ),
                  SizedBox(width: 8),

                  ChoiceChip(
                    label: Text("Today", style: TextStyle(fontSize: 16)),
                    showCheckmark: false,
                    selected: selectedOption == "Today",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                    ),
                    onSelected: (_) => _setToday(),
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text("Tomorrow", style: TextStyle(fontSize: 16)),
                    showCheckmark: false,
                    selected: selectedOption == "Tomorrow",
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onSelected: (_) => _setTomorrow(),
                  ),
                ],
              ),

              // to display the selected data
              if (selectedDate != null)
                ChoiceChip(
                  label: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    style: TextStyle(fontSize: 16),
                  ),
                  selected: selectedOption == "custom",
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedOption = "custom";
                    });
                  },
                ),
              SizedBox(height: 30),
              // Row(
              //   children: [
              //     IconButton(
              //       style: IconButton.styleFrom(
              //         padding: EdgeInsets.all(22),
              //         side: BorderSide(
              //           width: 2,
              //           color: Theme.of(context).colorScheme.outlineVariant,
              //         ),
              //       ),
              //       onPressed: () {},
              //       icon: Icon(Icons.add_alarm_outlined, size: 30),
              //     ),
              //     SizedBox(width: 10),

              //     IconButton(
              //       style: IconButton.styleFrom(
              //         padding: EdgeInsets.all(22),
              //         side: BorderSide(
              //           width: 2,
              //           color: Theme.of(context).colorScheme.outlineVariant,
              //         ),
              //       ),
              //       onPressed: () {},
              //       icon: Icon(Icons.notification_add_outlined, size: 30),
              //     ),
              //   ],
              // ),
              // SizedBox(height: 50),
              Text(
                "CATEGORIES",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              SizedBox(height: 16),
              CategorySelector(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),

              SizedBox(height: 20),
              Text(
                "TITLE",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: descController,
                decoration: InputDecoration(
                  labelText: "Description(optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.9, // Make it wide
                  height: 50,

                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: _handleCreateTask,

                    child: Text(
                      "Create",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
