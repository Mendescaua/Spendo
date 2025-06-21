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
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      // Carregar imagens do banco de dados
      ref.read(imagesControllerProvider.notifier).getImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imagesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Iconsax.arrow_left)),
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
                  // Botão de upload
                  InkWell(
                    onTap: () {
                      // lógica de upload
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 40),
                            SizedBox(height: 8),
                            Text(
                              'Enviar\nImagem',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Mostrar imagens carregadas
                  ...images
                      .map((image) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
