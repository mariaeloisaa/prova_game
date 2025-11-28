import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/players_create.dart';
import 'package:game_app/players_edit.dart';

class JogadoresListPage extends StatefulWidget {
  const JogadoresListPage({super.key});

  @override
  State<JogadoresListPage> createState() => _JogadoresListPageState();
}

class _JogadoresListPageState extends State<JogadoresListPage> {
  List<dynamic>? jogadores;

  @override
  void initState() {
    super.initState();
    getJogadores();
  }

  void getJogadores() {
    FirebaseFirestore.instance
        .collection("jogadores")
        .snapshots()
        .listen((snapshots) {
      final data = snapshots.docs;

      setState(() {
        jogadores = data;
      });
    });
  }

  Future<void> deleteJogador(String id) async {
    await FirebaseFirestore.instance
        .collection("jogadores")
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogadores"),
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
      body: jogadores == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jogadores!.length,
              itemBuilder: (context, index) {
                final item = jogadores![index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(Icons.person, size: 30, color: Colors.blue),
                    ),
                    title: Text(
                      item["nome"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: item["melhorTempo"] != null
                        ? Text("Melhor tempo: ${item["melhorTempo"]} ms")
                        : const Text("Sem tempo registrado"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditJogadorPage(
                                  id: item.id,
                                  nome: item["nome"],
                                  senha: item["senha"],
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteJogador(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
