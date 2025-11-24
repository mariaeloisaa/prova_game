import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddJogadorPage extends StatefulWidget {
  const AddJogadorPage({super.key});

  @override
  State<AddJogadorPage> createState() => _AddJogadorPageState();
}

class _AddJogadorPageState extends State<AddJogadorPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  Future<void> addJogador() async {
    FirebaseFirestore.instance.collection("jogadores").add({
      "nome": nomeController.text,
      "senha": senhaController.text,
      "melhorTempo": null, // opcional para ranking
    });
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Jogador")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: largura * 0.9,
              child: TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
            ),
            SizedBox(
              width: largura * 0.9,
              child: TextField(
                controller: senhaController,
                decoration: const InputDecoration(labelText: "Senha"),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addJogador();
              },
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
