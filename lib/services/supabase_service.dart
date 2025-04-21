import 'package:flutter/material.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseService extends ChangeNotifier {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  final _supabase = Supabase.instance.client;

  Future<List<Task>> getTasks() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<void> addTask(String title) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not logged in');
    }
    final _uuid = Uuid();

    await _supabase.from('tasks').insert({
      'id': _uuid.v4(),
      'user_id': userId,
      'title': title,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteTask(String id) async {
    await _supabase.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTaskStatus(String id, String currentStatus) async {
    await _supabase
        .from('tasks')
        .update({
          'status': currentStatus == 'pending' ? 'completed' : 'pending',
        })
        .eq('id', id);
  }
Future<void> updateTask(String id, String text) async {
    await _supabase
        .from('tasks')
        .update({'title': text, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
  Future<void> addUser(String userId, String email, String fullName) async {
    print("user name : ${fullName}");
    try {
      await _supabase.from('profiles').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Failed to add user $e");
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response =
        await _supabase.from('profiles').select().eq('id', userId).single();

    return response;
  }
}
