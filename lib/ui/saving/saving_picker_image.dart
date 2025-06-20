import 'package:flutter/material.dart';
import 'package:spendo/utils/base64.dart';
import 'package:spendo/utils/base64/imagesBase64.dart';

void main() {
  runApp(const MaterialApp(home: ImagePickerScreen()));
}

class ImagePickerScreen extends StatelessWidget {
  const ImagePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final base64Images = Base64Images.allImages;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar'),
        leading: const BackButton(),
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
                  // Imagens em base64
                  ...base64Images.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image: base64ToImage(img),
                        fit: BoxFit.cover,
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
