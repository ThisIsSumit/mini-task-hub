import 'package:flutter/material.dart';
import 'package:mini_taskhub/auth/auth_service.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';
import 'package:mini_taskhub/dashboard/task_tile.dart';
import 'package:mini_taskhub/services/supabase_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final _taskController = TextEditingController();
  final _supabaseService = SupabaseService();
  final _supabase = Supabase.instance.client;
  List<Task> _tasks = [];
  String _currentFilter = 'all';
  bool _isEditing = false;
  String? _editingTaskId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animationController.forward();
    _loadTasks();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    final tasks = await _supabaseService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _addTask() async {
    if (_taskController.text.isEmpty) return;

    if (_isEditing && _editingTaskId != null) {
      await _updateTask(_editingTaskId!, _taskController.text);
    } else {
      await _supabaseService.addTask(_taskController.text);
    }

    _taskController.clear();
    setState(() {
      _isEditing = false;
      _editingTaskId = null;
    });
    await _loadTasks();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _updateTask(String id, String text) async {
    await _supabase
        .from('tasks')
        .update({'title': text, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  Future<void> _deleteTask(String id) async {
    await _supabaseService.deleteTask(id);
    await _loadTasks();
  }

  Future<void> _toggleTaskStatus(Task task) async {
    await _supabaseService.toggleTaskStatus(task.id, task.status);
    await _loadTasks();
  }

  void _editTask(Task task) {
    _taskController.text = task.title;
    setState(() {
      _isEditing = true;
      _editingTaskId = task.id;
    });
    _showAddTaskDialog();
  }

  List<Task> get _filteredTasks {
    if (_currentFilter == 'all') return _tasks;
    return _tasks.where((task) => task.status == _currentFilter).toList();
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isEditing ? 'Edit Task' : 'Create New Task',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 20),
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.amber,
                        width: 2,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  autofocus: true,
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isEditing ? 'Update' : 'Create',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 60, 66, 68),
      appBar: AppBar(
        title: const Text(
          'TaskHub',
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _currentFilter == 'all',
                    onSelected: (_) => setState(() => _currentFilter = 'all'),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color:
                          _currentFilter == 'all' ? Colors.black : Colors.grey,
                      fontWeight:
                          _currentFilter == 'all'
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
                  ChoiceChip(
                    label: const Text('Pending'),
                    selected: _currentFilter == 'pending',
                    onSelected:
                        (_) => setState(() => _currentFilter = 'pending'),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color:
                          _currentFilter == 'pending'
                              ? Colors.black
                              : Colors.grey,
                      fontWeight:
                          _currentFilter == 'pending'
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 300.ms),
                  ChoiceChip(
                    label: const Text('Completed'),
                    selected: _currentFilter == 'completed',
                    onSelected:
                        (_) => setState(() => _currentFilter = 'completed'),
                    selectedColor: Colors.amber,
                    labelStyle: TextStyle(
                      color:
                          _currentFilter == 'completed'
                              ? Colors.black
                              : Colors.grey,
                      fontWeight:
                          _currentFilter == 'completed'
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 300.ms),
                ],
              ),
            ),
            Expanded(
              child:
                  _filteredTasks.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 64,
                              color: const Color.fromARGB(255, 255, 254, 254),
                            ).animate().fadeIn(duration: 500.ms).scale(),
                            const SizedBox(height: 16),
                            const Text(
                              'No tasks found',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = _filteredTasks[index];
                          return Slidable(
                            key: ValueKey(task.id),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => _editTask(task),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () => _deleteTask(task.id),
                                closeOnCancel: true,
                                confirmDismiss: () async {
                                  return await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.grey[850],
                                            title: const Text(
                                              'Delete Task',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this task?',
                                              style: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(false),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.of(
                                                      context,
                                                    ).pop(true),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ) ??
                                      false;
                                },
                              ),
                              children: [
                                SlidableAction(
                                  onPressed: (_) => _deleteTask(task.id),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                            child: TaskTile(
                                  task: task,
                                  onDelete: () => _deleteTask(task.id),
                                  onToggleStatus: () => _toggleTaskStatus(task),
                                )
                                .animate()
                                .fadeIn(
                                  delay: Duration(milliseconds: 100 * index),
                                  duration: 300.ms,
                                )
                                .slideX(begin: 0.05, end: 0),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          setState(() {
            _isEditing = false;
            _editingTaskId = null;
            _taskController.clear();
          });
          _showAddTaskDialog();
        },
        child: const Icon(Icons.add, color: Colors.black),
      ).animate().scale(delay: 400.ms, duration: 400.ms),
    );
  }
}
