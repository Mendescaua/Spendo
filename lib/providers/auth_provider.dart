import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider do usuário autenticado como Stream
final authUserStreamProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session?.user);
});

// Provider que retorna o ID do usuário autenticado, ou null se não carregou ainda
final currentUserId = Provider<String?>((ref) {
  final authState = ref.watch(authUserStreamProvider);
  return authState.maybeWhen(
    data: (user) => user?.id,
    orElse: () => null,
  );
});
