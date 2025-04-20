import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function() onDelete;
  final Function() onToggleStatus;
  final Function()? onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleStatus,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = task.status == 'completed';
    final statusColor = isCompleted ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              isCompleted
                  ? Colors.green.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(height: 4, color: statusColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ListTile(
                leading: InkWell(
                  onTap: onToggleStatus,
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? Colors.green : Colors.amber,
                        width: 2,
                      ),
                    ),
                    child:
                        isCompleted
                            ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ).animate().scale(duration: 300.ms)
                            : const SizedBox(width: 20, height: 20),
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat(
                              'MMM dd, yyyy • hh:mm a',
                            ).format(task.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          isDarkMode ? Colors.grey[900] : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (context) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (onEdit != null)
                                  ListTile(
                                    leading: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    title: const Text('Edit Task'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      onEdit!();
                                    },
                                  ),
                                ListTile(
                                  leading: Icon(
                                    isCompleted
                                        ? Icons.unpublished
                                        : Icons.task_alt,
                                    color:
                                        isCompleted
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                  title: Text(
                                    isCompleted
                                        ? 'Mark as Pending'
                                        : 'Mark as Completed',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    onToggleStatus();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: const Text('Delete Task'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text('Delete Task'),
                                            content: const Text(
                                              'Are you sure you want to delete this task?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: const Text('CANCEL'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  onDelete();
                                                },
                                                child: const Text(
                                                  'DELETE',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
