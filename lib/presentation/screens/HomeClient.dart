import 'package:flutter/material.dart';

void main() => runApp(const HomeClient());

class HomeClient extends StatelessWidget {
  const HomeClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CAMPAÑA DE VACUNACION 2023'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/cocacola.png"),
        ),
      ),
      //body: const ListProductsClients(),
    );
  }
}
