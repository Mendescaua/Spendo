import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/utils/theme.dart';
import 'package:image/image.dart' as img;


class CircleImage extends StatefulWidget {
  final String? initialBase64;
  final Function(String base64Image) onImageSelected;
  final double size;

  const CircleImage({
    super.key,
    this.initialBase64,
    required this.onImageSelected,
    this.size = 120,
  });

  @override
  State<CircleImage> createState() => _CircleImageState();
}

class _CircleImageState extends State<CircleImage> {
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _base64Image = widget.initialBase64;
  }

  Future<void> _pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source, imageQuality: 70);

  if (pickedFile != null) {
    final bytes = await File(pickedFile.path).readAsBytes();

    // Decode a imagem para manipular
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return;

    // Reduz a largura para no máximo 720, mantendo a proporção
    final resized = img.copyResize(image, width: 720);

    // Converte novamente para JPEG com qualidade 85 (ajuste se quiser)
    final resizedBytes = img.encodeJpg(resized, quality: 70);

    final base64Image = base64Encode(resizedBytes);

    setState(() {
      _base64Image = base64Image;
    });

    widget.onImageSelected(base64Image);
  }
}


  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.image(PhosphorIconsStyle.regular)),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(PhosphorIcons.camera(PhosphorIconsStyle.regular)),
              title: const Text('Tirar uma Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container com borda externa circular
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
            ),
          ),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              image: _base64Image != null
                  ? DecorationImage(
                      image: MemoryImage(base64Decode(_base64Image!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _base64Image == null
                ? const Center(
                    child: Icon(Icons.person,
                        size: 50, color: Colors.white),
                  )
                : null,
          ),
        ),

        // Botão circular com ícone de câmera
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _showImageSourceOptions,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                PhosphorIcons.camera(PhosphorIconsStyle.regular),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
