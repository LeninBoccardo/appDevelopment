import 'package:flutter/material.dart';

// Tela exemplo dos termos de uso
class TermsOfUse extends StatelessWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Lugar que supostamente teriam os termos de uso
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              "Termos de uso",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          Center(
            // Botão de retorno
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple[800],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Voltar'),
            ),
          ),
        ],
      ),
    );
  }
}
