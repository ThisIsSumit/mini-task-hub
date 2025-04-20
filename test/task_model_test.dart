import 'package:flutter_test/flutter_test.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';

void main() {
  group('Task Model Tests', () {
    test('Should correctly serialize from JSON', () {
      
      final jsonData = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'user_id': '123e4567-e89b-12d3-a456-426614174001',
        'title': 'Test Task',
        'status': 'pending',
        'created_at': '2023-10-20T12:00:00Z',
      };

      
      final task = Task.fromJson(jsonData);

      expect(task.id, equals('123e4567-e89b-12d3-a456-426614174000'));
      expect(task.userId, equals('123e4567-e89b-12d3-a456-426614174001'));
      expect(task.title, equals('Test Task'));
      expect(task.status, equals('pending'));
      expect(task.createdAt, equals(DateTime.parse('2023-10-20T12:00:00Z')));
    });

    test('Should handle missing optional fields with defaults', () {
      // Test that status defaults to 'pending' if not provided
      final jsonData = {
        'id': '123e4567-e89b-12d3-a456-426614174000',
        'user_id': '123e4567-e89b-12d3-a456-426614174001',
        'title': 'Test Task',
        'created_at': '2023-10-20T12:00:00Z',
      };

      final task = Task.fromJson(jsonData);
      expect(task.status, equals('pending'));
    });

    test('Should correctly convert to JSON', () {
      // 1. Arrange
      final task = Task(
        id: '123e4567-e89b-12d3-a456-426614174000',
        userId: '123e4567-e89b-12d3-a456-426614174001',
        title: 'Test Task',
        status: 'completed',
        createdAt: DateTime.parse('2023-10-20T12:00:00Z'),
      );

      // 2. Act
      final json = task.toJson();

      // 3. Assert
      expect(json['id'], equals('123e4567-e89b-12d3-a456-426614174000'));
      expect(json['user_id'], equals('123e4567-e89b-12d3-a456-426614174001'));
      expect(json['title'], equals('Test Task'));
      expect(json['status'], equals('completed'));
      expect(json['created_at'], equals('2023-10-20T12:00:00Z'));
    });
  });
}