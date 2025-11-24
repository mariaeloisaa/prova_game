import 'package:flutter/material.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool esperando = false;      // Jogador esperando ficar verde
  bool podeApertar = false;    // Já ficou verde
  int? inicio;                 // Timestamp do momento que ficou verde
  int? tempoFinal;             // Tempo final do usuário

  Color buttonColor = Colors.red; // Começa vermelho

  String mensagem = "Aperte para começar";

  // -------------------- INICIAR PARTIDA ---------------------
  void iniciar() {
    setState(() {
      esperando = true;
      podeApertar = false;
      tempoFinal = null;
      buttonColor = Colors.red;
      mensagem = "Espere ficar verde...";
    });

    int delay = 2000 + Random().nextInt(3000); // entre 2s e 5s

    Future.delayed(Duration(milliseconds: delay), () {
      if (!esperando) return;
      setState(() {
        podeApertar = true;
        esperando = false;
        buttonColor = Colors.green;
        mensagem = "AGORA!";
        inicio = DateTime.now().millisecondsSinceEpoch;
      });
    });
  }

  // -------------------- APERTOU BOTÃO ---------------------
  void apertou() {
    // Apertou cedo
    if (esperando) {
      setState(() {
        mensagem = "Muito cedo! Tente novamente.";
        esperando = false;
        podeApertar = false;
        buttonColor = Colors.red;
      });
      return;
    }

    // Apertou no momento certo
    if (podeApertar) {
      int fim = DateTime.now().millisecondsSinceEpoch;
      setState(() {
        tempoFinal = fim - inicio!;
        mensagem = "Seu tempo: ${tempoFinal}ms\nToque para jogar de novo!";
        podeApertar = false;
        buttonColor = Colors.blue;
      });

      // Depois vamos salvar esse tempo no Firebase aqui
      return;
    }

    // Se apertou fora de qualquer estado
    setState(() {
      mensagem = "Clique para iniciar";
      buttonColor = Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: Color(0xFF1565C0),
        title: const Text("Aperte Quando Ficar Verde", style: TextStyle(color: Colors.white)),
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),

              const SizedBox(height: 40),

              // BOTÃO GRANDE
              GestureDetector(
                onTap: () {
                  if (tempoFinal != null) {
                    // se terminou uma partida, reinicia ao tocar
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
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black26,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "CLIQUEME",
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
