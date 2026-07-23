import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/core/utils/show_snackbar.dart';
import 'package:planit/models/task_model.dart';
import 'package:planit/viewmodels/task_viewmodel.dart';
import 'package:planit/views/widgets/category_selector.dart';
import 'package:planit/views/widgets/neo_box.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({super.key});

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final Uuid uuid = const Uuid();
  late TextEditingController titleController;
  late TextEditingController descController;

  String selectedOption = "Today";
  DateTime selectedDate = DateTime.now();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedOption = "Custom";
      });
    }
  }

  void _setToday() {
    setState(() {
      selectedOption = "Today";
      selectedDate = DateTime.now();
    });
  }

  void _setTomorrow() {
    setState(() {
      selectedOption = "Tomorrow";
      selectedDate = DateTime.now().add(const Duration(days: 1));
    });
  }

  void _handleCreateTask() async {
    if (titleController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter a task title", SnackBarType.error);
      return;
    }
    if (selectedCategory == null) {
      showSnackBar(context, "Please select a category", SnackBarType.error);
      return;
    }

    final task = Task(
      id: uuid.v4(),
      title: titleController.text.trim(),
      description: descController.text.trim().isEmpty
          ? null
          : descController.text.trim(),
      category: selectedCategory!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      dueAt: selectedDate,
    );

    await ref.read(taskViewModelProvider.notifier).createTodo(task);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: NeoButton(
            padding: const EdgeInsets.all(8),
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("WHEN"),
            const SizedBox(height: 12),
            Row(
              children: [
                _dateChip("Today", selectedOption == "Today", _setToday),
                const SizedBox(width: 10),
                _dateChip(
                  "Tomorrow",
                  selectedOption == "Tomorrow",
                  _setTomorrow,
                ),
                const SizedBox(width: 10),
                NeoButton(
                  color: selectedOption == "Custom"
                      ? AppColors.primary
                      : AppColors.surfaceLight,
                  padding: const EdgeInsets.all(12),
                  shadowOffset: const Offset(3, 3),
                  onTap: _pickDate,
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Due: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 28),
            _label("CATEGORY"),
            const SizedBox(height: 14),
            CategorySelector(
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),

            const SizedBox(height: 28),
            _label("TITLE"),
            const SizedBox(height: 12),
            _field(controller: titleController, hint: "What's the plan?"),

            const SizedBox(height: 20),
            _label("DESCRIPTION"),
            const SizedBox(height: 12),
            _field(
              controller: descController,
              hint: "Add details (optional)",
              maxLines: 3,
            ),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: NeoButton(
                color: AppColors.secondary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                onTap: _handleCreateTask,
                child: const Center(
                  child: Text(
                    "Create task ✨",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
    ),
  );

  Widget _dateChip(String label, bool selected, VoidCallback onTap) {
    return NeoButton(
      color: selected ? AppColors.primary : AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      shadowOffset: const Offset(3, 3),
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return NeoBox(
      color: AppColors.surfaceLight,
      shadowOffset: const Offset(3, 3),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.ink.withValues(alpha: 0.4),
            fontWeight: FontWeight.w600,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
