import 'package:flutter/material.dart';
import '../widgets/task_card.dart';
import 'profile_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  int _currentIndex = 0;
  String _filter = 'All';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Due Date';

  List<Task> get _filteredTasks {
    List<Task> result = _tasks.where((task) {
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Completed' && task.isCompleted) ||
          (_filter == 'Pending' && !task.isCompleted);
      final matchesSearch = task.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    result.sort((a, b) {
      if (_sortBy == 'Due Date') return a.dueDate.compareTo(b.dueDate);
      const order = {'High': 0, 'Medium': 1, 'Low': 2};
      return (order[a.priority] ?? 1).compareTo(order[b.priority] ?? 1);
    });

    return result;
  }

  void _openTaskForm({Task? existingTask}) {
    final titleController =
    TextEditingController(text: existingTask?.title ?? '');
    final descController =
    TextEditingController(text: existingTask?.description ?? '');
    String category = existingTask?.category ?? 'School';
    String priority = existingTask?.priority ?? 'Medium';
    DateTime dueDate = existingTask?.dueDate ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00796B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add_task,
                              color: Color(0xFF00796B)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          existingTask == null ? 'Add New Task' : 'Edit Task',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Title
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Description
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['School', 'Personal', 'Health', 'Work']
                          .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => category = val!),
                    ),
                    const SizedBox(height: 12),
                    // Priority dropdown
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['Low', 'Medium', 'High']
                          .map((p) =>
                          DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (val) =>
                          setModalState(() => priority = val!),
                    ),
                    const SizedBox(height: 12),
                    // Date picker
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: dueDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setModalState(() => dueDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Color(0xFF00796B), size: 20),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Due Date',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600])),
                                Text(
                                  '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right,
                                color: Colors.grey[400]),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty ||
                              descController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Please fill in all fields')),
                            );
                            return;
                          }
                          setState(() {
                            if (existingTask == null) {
                              _tasks.add(Task(
                                title: titleController.text.trim(),
                                description: descController.text.trim(),
                                category: category,
                                priority: priority,
                                dueDate: dueDate,
                              ));
                            } else {
                              existingTask.title =
                                  titleController.text.trim();
                              existingTask.description =
                                  descController.text.trim();
                              existingTask.category = category;
                              existingTask.priority = priority;
                              existingTask.dueDate = dueDate;
                            }
                          });
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00796B),
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          existingTask == null
                              ? 'Add Task'
                              : 'Save Changes',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );  }

  @override
  Widget build(BuildContext context) {
    final int completed = _tasks.where((t) => t.isCompleted).length;
    final int total = _tasks.length;
    final double progress = total == 0 ? 0.0 : completed / total;

    final List<Widget> pages = [
      // Tasks Page
      Column(
        children: [
          // Stats banner
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00796B), Color(0xFF004D40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: _tasks.isEmpty
                ? const Column(
              children: [
                Text('Welcome to MembaMe!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Tap + to add your first task',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13)),
              ],
            )
                : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statChip('Total', total, Colors.white,
                        Colors.white24),
                    _statChip('Done', completed, Colors.greenAccent,
                        Colors.white24),
                    _statChip('Pending', total - completed,
                        Colors.orangeAccent, Colors.white24),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: Colors.greenAccent,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% of tasks completed',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((f) {
                final isSelected = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00796B)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF00796B)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                            : [],
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[600],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Task list
          Expanded(
            child: _filteredTasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00796B).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.checklist_rounded,
                        size: 70, color: Color(0xFF00796B)),
                  ),
                  const SizedBox(height: 24),
                  const Text('No tasks here!',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40))),
                  const SizedBox(height: 8),
                  Text('Tap the + button to add your first task',
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey[500])),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: _filteredTasks.length,
              itemBuilder: (_, i) {
                final task = _filteredTasks[i];
                return TaskCard(
                  task: task,
                  onDelete: () =>
                      setState(() => _tasks.remove(task)),
                  onToggleComplete: () => setState(
                          () => task.isCompleted = !task.isCompleted),
                  onEdit: () => _openTaskForm(existingTask: task),
                );
              },
            ),
          ),
        ],
      ),

      // ── Profile Page ──
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        elevation: 0,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => _searchQuery = val),
        )
            : Text(
          _currentIndex == 0 ? 'MembaMe' : 'My Profile',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchQuery = '';
                _searchController.clear();
              }
            }),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'Due Date', child: Text('Sort by Due Date')),
              const PopupMenuItem(
                  value: 'Priority', child: Text('Sort by Priority')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('Clear All Tasks'),
                  content: const Text(
                      'This will delete every task. Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear All',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true) setState(() => _tasks.clear());
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: () => _openTaskForm(),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task',
            style: TextStyle(fontWeight: FontWeight.bold)),
      )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF00796B),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rounded), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _statChip(
      String label, int count, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: textColor.withOpacity(0.8))),
        ],
      ),
    );
  }
}