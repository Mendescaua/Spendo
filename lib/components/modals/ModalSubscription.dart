import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ModalSubscription extends StatefulWidget {
  const ModalSubscription({super.key});

  @override
  State<ModalSubscription> createState() => _ModalSubscriptionState();
}

class _ModalSubscriptionState extends State<ModalSubscription> {
  DateTime? selectedDate;
  String? selectedCategory;
  IconData? selectedIcon = Iconsax.category;

  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {'label': 'Alimentação', 'icon': Iconsax.cake},
    {'label': 'Transporte', 'icon': Iconsax.car},
    {'label': 'Lazer', 'icon': Iconsax.game},
    {'label': 'Educação', 'icon': Iconsax.book},
    {'label': 'Saúde', 'icon': Iconsax.heart},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        width: double.infinity,
        height: size.height * 0.60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: const Text(
                'Adicionar nova assinatura',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Título',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.text_block),
                hintText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Data',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              controller: _controller,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.calendar),
                hintText: 'Selecione uma data',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Categoria',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3ECF9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(selectedIcon,
                      size: 20, color: const Color(0xFF4678c0)),
                ),
                hintText: 'Selecione uma categoria',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
              selectedItemBuilder: (context) {
                // Aqui mostramos apenas o nome da categoria no campo
                return categories.map<Widget>((category) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(category['label']),
                  );
                }).toList();
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['label'],
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3ECF9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(category['icon'],
                            size: 18, color: const Color(0xFF4678c0)),
                      ),
                      Text(category['label']),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                final category =
                    categories.firstWhere((c) => c['label'] == value);
                setState(() {
                  selectedCategory = value;
                  selectedIcon = category['icon'];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
