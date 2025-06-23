import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> cards = [
    {
      'number': '**** **** **** 1234',
      'name': 'Visa',
      'validity': '12/25',
      'color': '0xFF1E88E5',
    },
    {
      'number': '**** **** **** 5678',
      'name': 'MasterCard',
      'validity': '08/24',
      'color': '0xFFD32F2F',
    },
  ];

  final List<Map<String, String>> transactions = [
    {'title': 'Uber', 'date': '20 Jun', 'amount': '- R\$ 25,00'},
    {'title': 'Salário', 'date': '15 Jun', 'amount': '+ R\$ 2000,00'},
    {'title': 'Netflix', 'date': '10 Jun', 'amount': '- R\$ 45,90'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Carteira'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cartões',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),

            const SizedBox(height: 16),

            // Cartões
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Container(
                    width: 250,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(int.parse(card['color']!)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card['name']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          card['number']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Validade ${card['validity']}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Transações recentes
            const Text(
              'Transações Recentes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final isPositive = tx['amount']!.startsWith('+');

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          isPositive ? Colors.green : Colors.redAccent,
                      child: Icon(
                        isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(tx['title']!),
                    subtitle: Text(tx['date']!),
                    trailing: Text(
                      tx['amount']!,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Botões de ação (opcional)
            // Pode ser implementado na parte inferior fixo usando bottomNavigationBar ou FloatingActionButton
          ],
        ),
      ),
    );
  }
}
