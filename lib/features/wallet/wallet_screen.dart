import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments & wallet')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Wallet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Wallet balances and funding are not available yet.'),
            const Text('No funds are held by this app.'),
          ]),
        )),
        Text('Available payment method', style: Theme.of(context).textTheme.titleMedium),
        const ListTile(leading: Icon(Icons.local_shipping_outlined),
          title: Text('Pay on delivery'), subtitle: Text('Pay when your order arrives.')),
        const Divider(),
        Text('Planned integrations', style: Theme.of(context).textTheme.titleMedium),
        const ListTile(enabled: false, leading: Icon(Icons.credit_card),
          title: Text('Card or bank payment'), subtitle: Text('Requires a verified payment provider.')),
        const ListTile(enabled: false, leading: Icon(Icons.account_balance_wallet_outlined),
          title: Text('Wallet funding and transaction history'),
          subtitle: Text('Requires a secure server-managed ledger.')),
      ]),
    );
  }
}
