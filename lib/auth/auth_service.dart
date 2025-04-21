import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mini_taskhub/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Future<String?> signUp(String email, String password, String fullName) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      await SupabaseService().addUser(response.user!.id, email, fullName);
      return response.user?.id;
    } catch (e) {
      print('Signup failed: $e');
    }
  }

  Future<String?> login(String email, String password) async {
    print(email + " " + password);
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user?.id;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  String? get currentUserId => _supabase.auth.currentSession?.user.id;
}
