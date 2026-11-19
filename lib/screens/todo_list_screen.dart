import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../widgets/todo_tile.dart';
import 'add_todo_screen.dart';

/// Schermata principale che mostra l'elenco delle attività e il conteggio.
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  /// Stato locale dell'app: lista delle attività.
  final List<TodoItem> _todos = [];

  /// Calcola dinamicamente quante attività sono completate.
  int get _completedCount => _todos.where((todo) => todo.isCompleted).length;

  /// Cambia lo stato di un'attività (da fare <-> completata).
  void _toggleTodo(String id) {
    setState(() {
      final index = _todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        final current = _todos[index];
        _todos[index] = current.copyWith(isCompleted: !current.isCompleted);
      }
    });
  }

  /// Chiede conferma all'utente prima di eliminare un'attività (R4 / S4).
  Future<void> _confirmDeleteTodo(TodoItem todo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina attività'),
        content: Text('Vuoi eliminare "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _todos.removeWhere((item) => item.id == todo.id);
    });
  }

  /// Avvia la creazione di una nuova attività e gestisce il risultato (S1).
  Future<void> _navigateToAddTodo() async {
    final newTodo = await Navigator.of(context).push<TodoItem>(
      MaterialPageRoute(
        builder: (context) => const AddTodoScreen(),
      ),
    );

    if (!mounted || newTodo == null) return;

    setState(() {
      _todos.add(newTodo);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Attività "${newTodo.title}" aggiunta'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Chip(
                label: Text(
                  'Completate: $_completedCount / ${_todos.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _todos.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return TodoTile(
                  key: ValueKey(todo.id),
                  todo: todo,
                  onToggle: () => _toggleTodo(todo.id),
                  onDelete: () => _confirmDeleteTodo(todo),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTodo,
        tooltip: 'Aggiungi attività',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Mostra un messaggio chiaro quando non ci sono attività (S2 - variante).
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 72,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Nessuna attività presente',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Premi il pulsante + in basso a destra per aggiungere una nuova attività.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
