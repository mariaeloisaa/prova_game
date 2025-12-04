import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/players_create.dart';
import 'package:game_app/players_edit.dart';

class JogadoresListPage extends StatelessWidget {
  const JogadoresListPage({super.key});

  Future<void> _deleteJogador(BuildContext context, String id) async {
    final confirma = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmação"),
        content: const Text("Deseja realmente excluir este jogador?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Não")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Sim")),
        ],
      ),
    );

    if (confirma == true) {
      await FirebaseFirestore.instance.collection("jogadores").doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jogador removido"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogadores"),
        backgroundColor: const Color(0xFF00C4B4),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddJogadorPage()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("jogadores").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Nenhum jogador cadastrado ainda"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final nome = data["nome"] ?? "Sem nome";


              final melhorTempo = data.containsKey("melhorTempo")
                  ? data["melhorTempo"]
                  : null;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF21D8C3),
                    child: const Icon(Icons.person, size: 28, color: Colors.white),
                  ),
                  title: Text(
                    nome,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    melhorTempo != null
                        ? "Melhor tempo: ${melhorTempo} ms"
                        : "Sem tempo registrado",
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF009688)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditJogadorPage(
                                id: doc.id,
                                nome: nome,
                                senha: data["senha"] ?? "",
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                        onPressed: () => _deleteJogador(context, doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

        },
      ),
    );
  }
}
