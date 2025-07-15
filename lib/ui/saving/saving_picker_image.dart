import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/controllers/saving_image_controller.dart';

class ImagePickerScreen extends ConsumerStatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  ConsumerState<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends ConsumerState<ImagePickerScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Carregar imagens do banco de dados
      ref.read(imagesControllerProvider.notifier).getImages();
    });
  }

  bool isValidUrl(String url) {
    final cleaned = url.trim();
    final uri = Uri.tryParse(cleaned);
    final validExtensions = [
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.webp',
      '.bmp',
      '.svg'
    ];

    bool hasValidExtension =
        validExtensions.any((ext) => cleaned.toLowerCase().endsWith(ext));

    return uri != null &&
        uri.hasAbsolutePath &&
        (cleaned.startsWith('http://') || cleaned.startsWith('https://')) &&
        hasValidExtension;
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imagesControllerProvider);

    for (var img in images) {
      print('Imagem carregada: "$img"');
    }

    // Na sua tela:
    final validImages = images.where((image) {
      return isValidUrl(image) && !image.contains('.emptyFolderPlaceholder');
    }).toList();

    if (validImages.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha uma imagem',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  ...validImages.map((image) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(
                            context, image); // Retorna a URL da imagem
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
