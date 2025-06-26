import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/services/supabase_service.dart';

//eu uso isso para quando o usuario vai criar suas metas, ai ao escolher a imagem da meta eu carrego aqui
final imagesControllerProvider =
    StateNotifierProvider<ImagesController, List<String>>((ref) {
  return ImagesController(ref);
});

class ImagesController extends StateNotifier<List<String>> {
  final Ref ref;
  final SupabaseService _supabaseService = SupabaseService();

  ImagesController(this.ref) : super([]);

  Future<String?> getImages() async {
    try {
      final urls = await _supabaseService.getImagesSaving();
      // print('URLs obtidas: $urls');
      state = urls;
      return null;
    } catch (e) {
      print('Erro ao obter cofrinhos: $e');
      return 'Erro inesperado: $e';
    }
  }
}
