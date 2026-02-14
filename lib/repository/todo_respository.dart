import 'package:planit/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart' hide Task;

class TodoRespository {
  final _client = Supabase.instance.client;

  // READ
  Future<Either<String, List<Task>>> getAllTodos() async {
    try {
      final response = await _client.from('todos').select();

      final tasks = response
          .map((e) => Task.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();

      return Right(tasks); // success
    } catch (e) {
      return Left(e.toString()); // error as string
    }
  }

  //CREATE
  //( Convert Dart object to Map for database and convert Map back to Dart object for Flutter usage)
  Future<Either<String, Task>> createTodo(Task task) async {
    try {
      final response = await _client
          .from('todos')
          .insert(task.toMap())
          .select()
          .single();

      return Right(Task.fromMap(Map<String, dynamic>.from(response as Map)));
    } catch (e) {
      return Left(e.toString());
    }
  }

  // UPDATE
  Future<Either<String, Unit>> updateTodo(Task task) async {
    try {
      await _client.from('todos').update(task.toMap()).eq('id', task.id);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //DELETE
  Future<Either<String, Unit>> deleteTodo(String id) async {
    try {
      await _client.from('todos').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
