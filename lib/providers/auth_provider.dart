import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spendo/core/supabse_client.dart';

// Provider que escuta o estado de autenticação via Stream
final authUserStreamProvider = StreamProvider<User?>((ref) {
  return supabase.auth.onAuthStateChange.map((event) => event.session?.user);
});

// Provider que retorna o ID do usuário logado, baseado no Stream acima
final currentUserId = Provider<String?>((ref) {
  final userAsync = ref.watch(authUserStreamProvider);
  return userAsync.when(
    data: (user) => user?.id,
    loading: () => null,
    error: (_, __) => null,
  );
});
