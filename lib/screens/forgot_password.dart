import 'package:flutter/material.dart';

// Tela de "Esqueci minha senha"
// ignore: must_be_immutable
class ForgotPassword extends StatelessWidget {
  ForgotPassword({this.email, Key? key}) : super(key: key);

  // Variável que armazena o email da tela de login
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.purple[400],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mensagem que confirma o envio do email
              // OBS.: Essa funcionalidade não está funcionando devidamente
              // logo tal tela representa apenas um escopo
              Text(
                'Um email de recuperação foi enviado para $email',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              // Botão de retorno
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple[800],
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Voltar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
