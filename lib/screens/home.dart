import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_app/screens/login.dart';

// Escopo da tela home
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple[400],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Home Page',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              // Botão de retorno
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[900],
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  });
                },
                child: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
