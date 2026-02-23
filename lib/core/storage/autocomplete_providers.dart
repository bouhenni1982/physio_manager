import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_db_provider.dart';
import 'autocomplete_repository.dart';

final autocompleteRepositoryProvider = Provider<AutocompleteRepository>((ref) {
  final db = ref.watch(localDbProvider);
  return SqliteAutocompleteRepository(db);
});

final autocompleteProvider = FutureProvider.family<List<String>, AutocompleteQuery>((ref, query) {
  final repo = ref.watch(autocompleteRepositoryProvider);
  return repo.search(query.type, query.query);
});

class AutocompleteQuery {
  final String type;
  final String query;

  const AutocompleteQuery(this.type, this.query);
}
