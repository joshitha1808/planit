import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/models/task_model.dart';
import 'package:planit/viewmodels/task_viewmodel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String selectedFilter = 'All';
  final List<String> categories = [
    'All',
    'Work',
    'Personal',
    'Shopping',
    'Health',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() => ref.read(taskViewModelProvider.notifier).getAllTodos());
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Work';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: ['Work', 'Personal', 'Shopping', 'Health']
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedCategory = value ?? 'Work';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text,
                  category: selectedCategory,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  dueAt: DateTime.now().add(const Duration(days: 1)),
                  isCompleted: false,
                );
                ref.read(taskViewModelProvider.notifier).createTodo(newTask);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            hintText: 'Task title',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final updatedTask = Task(
                  id: task.id,
                  title: titleController.text,
                  description: task.description,
                  category: task.category,
                  createdAt: task.createdAt,
                  updatedAt: DateTime.now(),
                  dueAt: task.dueAt,
                  isCompleted: task.isCompleted,
                );
                ref
                    .read(taskViewModelProvider.notifier)
                    .updateTodo(updatedTask);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planit"),
        centerTitle: true,
        elevation: 0,
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
        data: (tasks) {
          final validTasks = tasks.whereType<Task>().toList();
          final filteredTasks = selectedFilter == 'All'
              ? validTasks
              : validTasks.where((t) => t.category == selectedFilter).toList();

          final incompleteTasks = filteredTasks
              .where((t) => !t.isCompleted)
              .toList();
          final completedTasks = filteredTasks
              .where((t) => t.isCompleted)
              .toList();

          return Column(
            children: [
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: categories
                      .map(
                        (category) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: Text(category),
                            selected: selectedFilter == category,
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = category;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              // Task List
              Expanded(
                child: (incompleteTasks.isEmpty && completedTasks.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.task_alt,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "No tasks found",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Try adjusting your filters",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Incomplete Tasks
                            if (incompleteTasks.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 12,
                                ),
                                child: Text(
                                  'Active Tasks',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              ...incompleteTasks.map(
                                (task) => _buildTaskCard(context, task),
                              ),
                            ],
                            // Completed Tasks
                            if (completedTasks.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  top: 24,
                                  bottom: 12,
                                ),
                                child: Text(
                                  'Completed Tasks',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              ...completedTasks.map(
                                (task) => _buildTaskCard(context, task),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return GestureDetector(
      onLongPress: () => _showEditTaskDialog(context, task),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Circular Checkbox
              GestureDetector(
                onTap: () {
                  final updatedTask = Task(
                    id: task.id,
                    title: task.title,
                    description: task.description,
                    category: task.category,
                    createdAt: task.createdAt,
                    updatedAt: DateTime.now(),
                    dueAt: task.dueAt,
                    isCompleted: !task.isCompleted,
                  );
                  ref
                      .read(taskViewModelProvider.notifier)
                      .updateTodo(updatedTask);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                    color: task.isCompleted ? Colors.blue : Colors.transparent,
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Task Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Edit Icon + Delete
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditTaskDialog(context, task);
                  } else if (value == 'delete') {
                    ref
                        .read(taskViewModelProvider.notifier)
                        .deleteTodo(task.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${task.title} deleted'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                child: Icon(Icons.more_vert, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
