import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditJogadorPage extends StatefulWidget {
  final String id;
  final String nome;
  final String senha;

  const EditJogadorPage({
    super.key,
    required this.id,
    required this.nome,
    required this.senha,
  });

  @override
  State<EditJogadorPage> createState() => _EditJogadorPageState();
}

class _EditJogadorPageState extends State<EditJogadorPage> {
  late TextEditingController nomeController;
  late TextEditingController senhaController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.nome);
    senhaController = TextEditingController(text: widget.senha);
  }

  Future<void> updateJogador() async {
    FirebaseFirestore.instance.collection("jogadores").doc(widget.id).set({
      "nome": nomeController.text,
      "senha": senhaController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Jogador")),
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
              onPressed: updateJogador,
              child: const Text("Atualizar"),
            )
          ],
        ),
      ),
    );
  }
}
