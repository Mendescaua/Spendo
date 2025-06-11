import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendo/core/supabse_client.dart';

// Stream do usuário autenticado
final authUserStreamProvider = StreamProvider<User?>((ref) async* {
  yield supabase.auth.currentUser;
  await for (final event in supabase.auth.onAuthStateChange) {
    yield event.session?.user;
  }
});

// ID do usuário autenticado
final currentUserId = Provider<String?>((ref) {
  final userAsync = ref.watch(authUserStreamProvider);
  return userAsync.when(
    data: (user) => user?.id,
    loading: () => null,
    error: (_, __) => null,
  );
});
