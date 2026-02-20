import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/utils/show_snackbar.dart';
import 'package:planit/models/task_model.dart';
import 'package:planit/viewmodels/task_viewmodel.dart';
import 'package:planit/views/add_task_page.dart';
import 'package:planit/views/widgets/home_drawer.dart';

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
    Future(() {
      ref.read(taskViewModelProvider.notifier).getAllTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskViewModelProvider);

    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text("Planit"),
        centerTitle: true,
        elevation: 0,
      ),
      body: tasksAsync.when(
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(category),
                        selected: selectedFilter == category,
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              Expanded(
                child: (incompleteTasks.isEmpty && completedTasks.isEmpty)
                    ? _buildEmptyState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Active Tasks
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No tasks found",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                final updatedTask = Task(
                  id: task.id,
                  userId: "",
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

            /// Task Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  //description
                  if (task.description != null && task.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        task.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  //date
                  if (task.dueAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Text(
                            "${task.dueAt!.day}/${task.dueAt.month}/${task.dueAt.year}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  ref.read(taskViewModelProvider.notifier).deleteTodo(task.id);

                  showSnackBar(
                    context,
                    '${task.title} deleted',
                    SnackBarType.error,
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
              child: Icon(Icons.more_vert, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}
