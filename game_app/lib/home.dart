import 'package:flutter/material.dart';
import 'package:game_app/ranking.dart';
import 'dart:math';
import '../auth.dart';
import 'package:game_app/game.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  String formatarData(DateTime data) {
    const meses = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];
    return "${data.day} de ${meses[data.month - 1]} de ${data.year}";
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    final mensagens = [
      "Pronto pra jogar?",
      "Vamos treinar seus reflexos!",
      "Seja o mais rápido do Senai",
      "Você consegue ser mais rápido?",
      "É hora do desafio!"
    ];

    final mensagem = mensagens[Random().nextInt(mensagens.length)];
    final dataFormatada = formatarData(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,

      
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C4B4),
        title: const Text("Game App", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // título "Olá jogador"
              Text(
                "Olá, ${usuarioLogadoNome ?? "Jogador"}!",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF009688), 
                ),
              ),

              const SizedBox(height: 8),

              Text(
                mensagem,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4F4F4F),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  dataFormatada,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4F4F4F),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //card jogo
              Container(
                width: w,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bolt, color: Color(0xFF009688), size: 30),
                        SizedBox(width: 10),
                        Text(
                          "Desafio do Dia",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009688),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Aperte quando o botão ficar verde o mais rápido possível",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GamePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C4B4),
                        minimumSize: Size(w * 0.7, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text(
                        "Jogar Agora",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              //card rankin
              Container(
                width: w,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.leaderboard,
                            color: Color(0xFF21D8C3), size: 30),
                        SizedBox(width: 10),
                        Text(
                          "Ranking Geral",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF21D8C3),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Fique de olho no pódio",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RankingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009688),
                        minimumSize: Size(w * 0.7, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.list, color: Colors.white),
                      label: const Text(
                        "Ver Ranking",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
