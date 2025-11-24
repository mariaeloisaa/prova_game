import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_app/players_create.dart';
import 'package:game_app/players_edit.dart';

import 'players_edit.dart';
import 'players_create.dart';

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
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddJogadorPage()));
            },
          )
        ],
      ),
      body: jogadores == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jogadores!.length,
              itemBuilder: (context, index) {
                final item = jogadores![index];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(item["nome"]),
                  subtitle: Text("Senha: ${item["senha"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: const Icon(Icons.edit, color: Colors.blue),
                        onTap: () {
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
                      const SizedBox(width: 15),
                      GestureDetector(
                        child: const Icon(Icons.delete, color: Colors.red),
                        onTap: () => deleteJogador(item.id),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
