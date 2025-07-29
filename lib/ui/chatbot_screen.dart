import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/controllers/chat_controller.dart'; // Ajuste seu import
import 'package:spendo/utils/theme.dart'; // Ajuste seu import

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final chatController = ref.read(chatControllerProvider('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').notifier);


    FocusScope.of(context).unfocus();

    chatController.sendMessage(text);
    _textController.clear();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final chatController = ref.read(chatControllerProvider('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').notifier);

    await chatController.pickImage(File(picked.path), picked.name);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider('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'));


    return Scaffold(
      appBar: AppBar(
        title: const Text('SpenAi', style: TextStyle(color: Colors.white)),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.length,
              itemBuilder: (_, i) {
                final msg = chatState.messages[i];

                // Se mensagem for do tipo typing indicator
                if (msg['isTyping'] == true) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const SizedBox(
                        width: 60,
                        height: 24,
                        child: TypingIndicator(),
                      ),
                    ),
                  );
                }

                final isUser = msg['isUser'] as bool;
                final bgColor =
                    isUser ? AppTheme.primaryColor : Colors.grey[800];
                final align =
                    isUser ? Alignment.centerRight : Alignment.centerLeft;

                return Align(
                  alignment: align,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: msg['image'] != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.file(msg['image'], width: 200),
                              const SizedBox(height: 4),
                              Text(
                                msg['text'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                        : Text(
                            msg['text'],
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.dynamicCardColor(context),
                  ),
                  child: IconButton(
                    icon: Icon(
                      PhosphorIcons.paperclip(PhosphorIconsStyle.regular),
                      size: 28,
                    ),
                    onPressed: _pickImage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Digite +100 mercado',
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          PhosphorIcons.paperPlaneRight(
                              PhosphorIconsStyle.regular),
                          size: 28,
                        ),
                        onPressed: () => _sendMessage(_textController.text),
                      ),
                      
                      filled: true,
                      fillColor: AppTheme.dynamicCardColor(context),
                      contentPadding: const EdgeInsets.only(left: 16, right: 4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Theme.of(context).primaryColor,
      size: 42,
    );
  }
}
