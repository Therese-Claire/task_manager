import 'package:flutter/material.dart';
import '../screens/task_detail_screen.dart';

// ── Task Model ──
class Task {
  String title;
  String description;
  String category;
  String priority;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });
}

Color priorityColor(String priority) {
  switch (priority) {
    case 'High':
      return Colors.red;
    case 'Medium':
      return Colors.orange;
    default:
      return Colors.green;
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'School':
      return Icons.school;
    case 'Health':
      return Icons.favorite;
    case 'Work':
      return Icons.work;
    default:
      return Icons.person;
  }
}

// ── TaskCard Widget ──
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverdue =
        !task.isCompleted && task.dueDate.isBefore(DateTime.now());

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text('Delete',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailScreen(
                task: task,
                onDelete: onDelete,
                onToggleComplete: onToggleComplete,
                onEdit: onEdit,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: isOverdue ? const Color(0xFFFFF3F3) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverdue
                  ? Colors.red.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Category icon circle
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00796B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(categoryIcon(task.category),
                      color: const Color(0xFF00796B), size: 22),
                ),
                const SizedBox(width: 12),
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? Colors.grey
                              : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 12,
                              color:
                              isOverdue ? Colors.red : Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                              isOverdue ? Colors.red : Colors.grey[500],
                            ),
                          ),
                          if (isOverdue) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Overdue',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Priority badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor(task.priority).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          color: priorityColor(task.priority),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Completion status dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? Colors.green
                            : Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}