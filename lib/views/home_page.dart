import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:planit/core/utils/show_snackbar.dart';
import 'package:planit/models/task_model.dart';
import 'package:planit/viewmodels/task_viewmodel.dart';
import 'package:planit/views/add_task_page.dart';
import 'package:planit/views/widgets/home_drawer.dart';
import 'package:planit/views/widgets/neo_box.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String selectedFilter = 'All';

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
      drawer: const HomeDrawer(),
      appBar: AppBar(
        title: const Text("Planit"),
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 12),
            child: NeoButton(
              padding: const EdgeInsets.all(8),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(Icons.menu_rounded, color: AppColors.ink),
            ),
          ),
        ),
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
        data: (tasks) {
          final validTasks = tasks.whereType<Task>().toList();

          /// Dynamic categories
          final taskCategories = validTasks
              .map((task) => task.category)
              .where((category) => category.isNotEmpty)
              .toSet()
              .toList();

          final categories = ['All', ...taskCategories];

          if (!categories.contains(selectedFilter)) {
            selectedFilter = 'All';
          }

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
              _CategoryBar(
                categories: categories,
                selected: selectedFilter,
                onSelected: (c) => setState(() => selectedFilter = c),
              ),
              Expanded(
                child: (incompleteTasks.isEmpty && completedTasks.isEmpty)
                    ? _buildEmptyState()
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        children: [
                          if (incompleteTasks.isNotEmpty) ...[
                            _sectionLabel('Active', Icons.bolt_rounded),
                            ...incompleteTasks.map(
                              (task) => _buildTaskCard(context, task),
                            ),
                          ],
                          if (completedTasks.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _sectionLabel(
                              'Done',
                              Icons.check_circle_rounded,
                            ),
                            ...completedTasks.map(
                              (task) => _buildTaskCard(context, task),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: NeoButton(
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_rounded, color: AppColors.ink),
            SizedBox(width: 6),
            Text(
              "New task",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, IconData icon) => Padding(
    padding: const EdgeInsets.only(left: 4, top: 8, bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 22, color: AppColors.ink),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeoBox(
            color: AppColors.pastels[3],
            padding: const EdgeInsets.all(28),
            child: const Icon(
              Icons.task_alt_rounded,
              size: 64,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "All clear!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap “New task” to plan something.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    final accent = AppColors.pastelFor(task.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NeoBox(
        color: task.isCompleted
            ? Theme.of(context).colorScheme.surface
            : accent,
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Toggle complete
            GestureDetector(
              onTap: () {
                final updatedTask = task.copyWith(
                  updatedAt: DateTime.now(),
                  isCompleted: !task.isCompleted,
                );
                ref
                    .read(taskViewModelProvider.notifier)
                    .updateTodo(updatedTask);
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: AppStyles.border(),
                  color: task.isCompleted
                      ? AppColors.secondary
                      : AppColors.surfaceLight,
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 18, color: AppColors.ink)
                    : null,
              ),
            ),
            const SizedBox(width: 14),

            /// Task info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w800,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _tag(task.category, AppColors.surfaceLight),
                      const SizedBox(width: 8),
                      _tag(
                        "${task.dueAt.day}/${task.dueAt.month}/${task.dueAt.year}",
                        AppColors.surfaceLight,
                        icon: Icons.calendar_today_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Delete
            GestureDetector(
              onTap: () {
                ref.read(taskViewModelProvider.notifier).deleteTodo(task.id);
                showSnackBar(
                  context,
                  '${task.title} deleted',
                  SnackBarType.error,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceLight,
                  border: AppStyles.border(),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        border: AppStyles.border(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: AppColors.ink),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final category = categories[i];
          final isSelected = category == selected;
          return NeoButton(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shadowOffset: const Offset(3, 3),
            onTap: () => onSelected(category),
            child: Center(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
