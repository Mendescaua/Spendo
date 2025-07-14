import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  final String label; // o que deve ser digitado para confirmar
  final void Function() onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.label,
    required this.onConfirm,
  });

  @override
  State<ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
  late TextEditingController _controller;
  bool _isMatching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {
        _isMatching = _controller.text.trim().toLowerCase() ==
            widget.label.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirmar Exclusão',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Digite para "${widget.label}" a exclusão:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.trash),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _isMatching
                ? AppTheme.dynamicRedColor(context)
                : Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: _isMatching ? widget.onConfirm : null,
          child: Text('Excluir', style: TextStyle(color: AppTheme.whiteColor)),
        ),
      ],
    );
  }
}
