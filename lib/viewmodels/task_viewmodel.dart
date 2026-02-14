import 'package:planit/models/task_model.dart';
import 'package:planit/repository/todo_respository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart' hide Task;

part 'task_viewmodel.g.dart';

@riverpod
class TaskViewModel extends _$TaskViewModel {
  late final TodoRespository todoRespository;

  @override
  AsyncValue<List<Task>> build() {
    todoRespository = TodoRespository();
    return const AsyncValue.data([]);
  }

  // read
  Future<void> getAllTodos() async {
    state = const AsyncValue.loading();
    Either<String, List<Task>> result = await todoRespository.getAllTodos();
    result.fold(
      (error) =>
          state = AsyncValue.error(error, StackTrace.current), // Left = error
      (tasks) => state = AsyncValue.data(tasks), // Right = success
    );
  }

  //create
  Future<void> createTodo(Task task) async {
    state = const AsyncValue.loading();

    Either<String, Task> result = await todoRespository.createTodo(task);

    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => getAllTodos(), // refresh list after success
    );
  }

  // update
  Future<void> updateTodo(Task task) async {
    state = const AsyncValue.loading();

    Either<String, Unit> result = await todoRespository.updateTodo(task);

    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => getAllTodos(),
    );
  }

  // delete
  Future<void> deleteTodo(String id) async {
    state = const AsyncValue.loading();

    Either<String, Unit> result = await todoRespository.deleteTodo(id);

    result.fold(
      (error) => state = AsyncValue.error(error, StackTrace.current),
      (_) => getAllTodos(),
    );
  }
}
