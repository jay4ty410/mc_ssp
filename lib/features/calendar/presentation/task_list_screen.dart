import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../providers/repository_providers.dart';
import '../../../providers/firebase_providers.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId != null) {
        ref.read(taskControllerProvider.notifier).loadUpcoming(userId);
      }
    });
  }

  Future<void> _showCreateTaskModal() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const CreateTaskModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskModal,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TaskState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    if (state.tasks.isEmpty) {
      return const Center(child: Text('No pending tasks yet.'));
    }

    return ListView.builder(
      itemCount: state.tasks.length,
      itemBuilder: (context, index) {
        final task = state.tasks[index];
        return ListTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _priorityColor(task.priority),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(task.title),
          subtitle: Text(
            'Due ${task.dueDate.toLocal().toString().split(' ')[0]}',
          ),
          trailing: task.status == TaskStatus.completed
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.radio_button_unchecked),
          onTap: () async {
            final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
            if (userId == null) return;
            await ref.read(taskControllerProvider.notifier).update(
              userId,
              task.id,
              {'status': TaskStatus.completed.name, 'isCompleted': true},
            );
          },
        );
      },
    );
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      default:
        return Colors.blueAccent;
    }
  }
}

class CreateTaskModal extends ConsumerStatefulWidget {
  const CreateTaskModal({super.key});

  @override
  ConsumerState<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends ConsumerState<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (userId == null) return;

    final task = TaskModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dueDate: _selectedDate,
      createdAt: DateTime.now(),
      priority: 'medium',
    );

    await ref.read(taskControllerProvider.notifier).create(userId, task);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'New Task',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a title'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Due date'),
              subtitle: Text(_selectedDate.toLocal().toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}
