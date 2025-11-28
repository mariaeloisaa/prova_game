import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loading.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  String error = "";

  //login admin blocado
  final String adminUser = "admin";
  final String adminPass = "123456";

  Future<void> login() async {
    final username = user.text.trim();
    final pass = password.text.trim();

    
    if (username == adminUser && pass == adminPass) {
      usuarioLogadoId = null;
      usuarioLogadoNome = "admin";

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoadingApiPage()),
      );
      return;
    }

    //login tabela jogadores 
    try {
      final result = await FirebaseFirestore.instance
          .collection("jogadores")
          .where("nome", isEqualTo: username)
          .where("senha", isEqualTo: pass)
          .get();

      if (result.docs.isNotEmpty) {
        usuarioLogadoId = result.docs.first.id;
        usuarioLogadoNome = username;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoadingApiPage()),
        );
      } else {
        setState(() => error = "Usuário ou senha incorretos");
      }
    } catch (e) {
      setState(() => error = "Erro ao conectar com o banco de dados");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      body: Center(
        child: Container(
          width: w * 0.85,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                blurRadius: 15,
                spreadRadius: 2,
                offset: Offset(0, 4),
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF80DEEA), 
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_pin_circle,
                  size: 70,
                  color: Color(0xFF006064),
                ),
              ),

              const SizedBox(height: 25),

              
              TextField(
                controller: user,
                decoration: InputDecoration(
                  labelText: "Usuário",
                  labelStyle: const TextStyle(color: Color(0xFF00838F)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00ACC1), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: const TextStyle(color: Color(0xFF00838F)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF00ACC1), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ACC1),
                  minimumSize: Size(w * 0.5, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),

              const SizedBox(height: 15),

              
              if (error.isNotEmpty)
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
