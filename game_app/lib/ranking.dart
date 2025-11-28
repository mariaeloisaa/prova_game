import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008781),
        title: const Text(
          "Ranking Geral",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("jogadores")
            .orderBy("melhorTempo")
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final dados = snapshot.data!.docs;

 //ranking
          List<Map<String, dynamic>> ranking = [];
          for (var doc in dados) {
            final item = doc.data() as Map<String, dynamic>;
            if (item["melhorTempo"] != null) {
              ranking.add(item);
            }
          }

          if (ranking.isEmpty) {
            return const Center(
              child: Text(
                "Ninguém registrou tempo ainda!",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [

              // PÓDIO
              podio(ranking),
              const SizedBox(height: 30),

//quarto lugar em diante
              for (int i = 3; i < ranking.length; i++)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "#${i + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          ranking[i]["nome"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${ranking[i]["melhorTempo"]} ms",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }


  Widget podio(List ranking) {
    final primeiro = ranking[0];
    final segundo = ranking.length > 1 ? ranking[1] : null;
    final terceiro = ranking.length > 2 ? ranking[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        if (segundo != null)
          blocoPodio(
            pos: 2,
            nome: segundo["nome"],
            tempo: segundo["melhorTempo"],
            altura: 130,
            cor: const Color(0xFF3AB8B0),
            icone: Icons.military_tech,
          ),

        const SizedBox(width: 12),

        blocoPodio(
          pos: 1,
          nome: primeiro["nome"],
          tempo: primeiro["melhorTempo"],
          altura: 170,
          cor: const Color(0xFF008781),
          icone: Icons.emoji_events,
        ),

        const SizedBox(width: 12),

        if (terceiro != null)
          blocoPodio(
            pos: 3,
            nome: terceiro["nome"],
            tempo: terceiro["melhorTempo"],
            altura: 110,
            cor: const Color(0xFF6DDBD7),
            icone: Icons.flag_circle,
          ),
      ],
    );
  }

//pódio
  Widget blocoPodio({
    required int pos,
    required String nome,
    required int tempo,
    required double altura,
    required Color cor,
    required IconData icone,
  }) {
    return Column(
      children: [
        Icon(icone, size: 40, color: const Color(0xFF006C6A)),
        const SizedBox(height: 5),

        Container(
          width: 100,
          height: altura,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "#$pos",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nome,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$tempo ms",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
