import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool esperando = false;
  bool podeApertar = false;
  int? inicio;
  int? tempoFinal;

  
  final Color corFundo = const Color(0xFF9AFFFF);
  final Color corAppBar = const Color(0xFF008781);
  final Color textoPadrao = const Color(0xFF006C6A);

  Color buttonColor = Colors.red;
  String mensagem = "Aperte para começar";

  
  
  Future<int?> verificarRanking(int tempo) async {
    final snap = await FirebaseFirestore.instance
        .collection("jogadores")
        .where("melhorTempo", isNotEqualTo: null)
        .orderBy("melhorTempo")
        .limit(3)
        .get();

    List<int> topTempos =
        snap.docs.map((d) => d["melhorTempo"] as int).toList();

    for (int i = 0; i < topTempos.length; i++) {
      if (tempo < topTempos[i]) return i + 1;
    }

    if (topTempos.length < 3) return topTempos.length + 1;

    return null; 
  }

  
  
  Future<bool> salvarTempo(int t) async {
    if (usuarioLogadoId == null) return false;

    final ref = FirebaseFirestore.instance
        .collection("jogadores")
        .doc(usuarioLogadoId);

    final doc = await ref.get();
    final dados = doc.data()!;

    if (dados["melhorTempo"] == null) {
      await ref.update({"melhorTempo": t});
      return true; 
    }

    int antigo = dados["melhorTempo"];

    if (t < antigo) {
      await ref.update({"melhorTempo": t});
      return true;
    }

    return false; 
  }

  
  void iniciar() {
    setState(() {
      esperando = true;
      podeApertar = false;
      tempoFinal = null;
      buttonColor = Colors.red;
      mensagem = "Espere ficar verde...";
    });

    int delay = 2000 + Random().nextInt(3000);

    Future.delayed(Duration(milliseconds: delay), () {
      if (!esperando) return;
      setState(() {
        podeApertar = true;
        esperando = false;
        buttonColor = Colors.green;
        mensagem = "Agora!";
        inicio = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  void apertou() async {
    if (esperando) {
      setState(() {
        mensagem = "Muito cedo. Tente novamente.";
        esperando = false;
        podeApertar = false;
        buttonColor = Colors.red;
      });
      return;
    }

    if (podeApertar) {
      int fim = DateTime.now().millisecondsSinceEpoch;
      int t = fim - inicio!;

      setState(() {
        tempoFinal = t;
        buttonColor = corAppBar;
      });

      
      bool bateuRecorde = await salvarTempo(t);

      int? posicao = await verificarRanking(t);

      String retorno = "Seu tempo: ${t}ms";

      if (bateuRecorde) {
        retorno += "\nNovo recorde pessoal.";
      }

      if (posicao != null && posicao <= 3) {
        retorno += "\nVocê entrou para o PÓDIOOOO: $posicaoº lugar.";
      }

      retorno += "\nToque para jogar de novo.";

      setState(() => mensagem = retorno);
      podeApertar = false;

      return;
    }

    setState(() {
      mensagem = "Clique para iniciar";
      buttonColor = Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: corAppBar,
        title: const Text(
          "CLIQUE QUANDO FICAR VERDE",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                mensagem,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textoPadrao,
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: () {
                  if (tempoFinal != null) {
                    iniciar();
                  } else if (!esperando && !podeApertar) {
                    iniciar();
                  } else {
                    apertou();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: w * 0.7,
                  height: w * 0.7,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black26,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "TOCAR",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
