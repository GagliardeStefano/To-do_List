import 'package:flutter/material.dart';
import '../models/todo_item.dart';

/// Schermata per la creazione di una nuova attività (R1 / S1).
class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isImportant = false;
  String? _titleError;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// Valida i dati inseriti e, se validi, restituisce la nuova attività.
  void _submit() {
    final trimmedTitle = _titleController.text.trim();
    if (trimmedTitle.isEmpty) {
      setState(() {
        _titleError = 'Il titolo è obbligatorio';
      });
      return;
    }

    final newTodo = TodoItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      isImportant: _isImportant,
    );

    Navigator.of(context).pop(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova attività'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              onChanged: (value) {
                // Rimuove l'errore appena l'utente inserisce un titolo valido.
                if (_titleError != null && value.trim().isNotEmpty) {
                  setState(() {
                    _titleError = null;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Titolo *',
                hintText: 'Es. Preparare la demo Flutter',
                border: const OutlineInputBorder(),
                errorText: _titleError,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Attività importante'),
              subtitle: const Text('Evidenzia questa attività nell\'elenco'),
              secondary: Icon(
                Icons.star_rounded,
                color: _isImportant ? Colors.amber : null,
              ),
              value: _isImportant,
              onChanged: (value) {
                setState(() {
                  _isImportant = value;
                });
              },
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Aggiungi attività'),
            ),
          ],
        ),
      ),
    );
  }
}
