import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:game_app/navbar.dart';
import 'package:http/http.dart' as http;

class LoadingApiPage extends StatefulWidget {
  const LoadingApiPage({super.key});

  @override
  State<LoadingApiPage> createState() => _LoadingApiPageState();
}

class _LoadingApiPageState extends State<LoadingApiPage> {
  String? frase;

  @override
  void initState() {
    super.initState();
    pegarFrase();
    mudarPagina();
  }

  //consumindo api
  void pegarFrase() async {
    final response = await http.get(
      Uri.parse("https://api.adviceslip.com/advice"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        frase = data["slip"]["advice"];
      });
    }
  }

  //tempo
  void mudarPagina() async {
    await Future.delayed(const Duration(seconds: 6));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavBar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00ACC1),
      body: Center(
        child: frase == null
            ? const CircularProgressIndicator(color: Colors.white)
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  frase!,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}
