import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Wallet')),
    body: const Center(child: Padding(
      padding: EdgeInsets.all(24),
      child: Text('Wallet is coming next. No payment method is connected yet.',
        textAlign: TextAlign.center),
    )),
  );
}
