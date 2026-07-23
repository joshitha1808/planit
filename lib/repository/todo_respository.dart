import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart' hide Task;
import 'package:planit/core/database/app_database.dart';
import 'package:planit/models/task_model.dart';

class TodoRespository {
  final AppDatabase _db;

  TodoRespository(this._db);

  Task _toTask(Todo row) {
    return Task(
      id: row.id,
      title: row.title,
      description: row.description,
      category: row.category,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      dueAt: row.dueAt,
      isCompleted: row.isCompleted,
    );
  }

  TodosCompanion _toCompanion(Task task) {
    return TodosCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      category: Value(task.category),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
      dueAt: Value(task.dueAt),
      isCompleted: Value(task.isCompleted),
    );
  }

  // READ
  Future<Either<String, List<Task>>> getAllTodos() async {
    try {
      final rows = await _db.select(_db.todos).get();
      final tasks = rows.map(_toTask).toList();
      return Right(tasks); // success
    } catch (e) {
      return Left(e.toString()); // error as string
    }
  }

  // CREATE
  Future<Either<String, Task>> createTodo(Task task) async {
    try {
      await _db.into(_db.todos).insert(_toCompanion(task));
      return Right(task);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // UPDATE
  Future<Either<String, Unit>> updateTodo(Task task) async {
    try {
      await _db.update(_db.todos).replace(_toCompanion(task));
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // DELETE
  Future<Either<String, Unit>> deleteTodo(String id) async {
    try {
      await (_db.delete(_db.todos)..where((t) => t.id.equals(id))).go();
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
