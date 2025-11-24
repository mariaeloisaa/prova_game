import 'package:flutter/material.dart';
import 'loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();

  String error = "";

  String correctUser = "admin";
  String correctPassword = "123456";

  void login() {
    if (user.text == correctUser && password.text == correctPassword) {
      setState(() => error = "");

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoadingApiPage()),
      );
    } else {
      setState(() {
        error = "Credenciais incorretas";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD), 
      body: Center(
        child: Container(
          width: w * 0.85,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 4),
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // LOGO
              Container(
                height: 120,
                width: 120,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 25),

              // INPUT USUÁRIO
              TextField(
                controller: user,
                decoration: InputDecoration(
                  labelText: "Usuário",
                  labelStyle: TextStyle(color: Color(0xFF1565C0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1565C0)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // INPUT SENHA
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(color: Color(0xFF1565C0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1565C0)),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // BOTÃO LOGIN
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E88E5),
                  minimumSize: Size(w * 0.6, 45),
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 10),

              // ERRO
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
