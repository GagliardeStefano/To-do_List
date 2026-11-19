/// Rappresenta una singola attività della to-do list.
class TodoItem {
  /// Identificativo univoco dell'attività (utile per aggiornamenti, eliminazioni e Key nei widget).
  final String id;

  /// Titolo obbligatorio che descrive l'attività.
  final String title;

  /// Stato dell'attività: `false` = da fare (default), `true` = completata.
  final bool isCompleted;

  /// Indica se l'attività è importante (`false` per default).
  final bool isImportant;

  const TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isImportant = false,
  });

  /// Restituisce una nuova istanza di [TodoItem] aggiornando solo i campi specificati.
  TodoItem copyWith({
    String? title,
    bool? isCompleted,
    bool? isImportant,
  }) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
    );
  }
}
