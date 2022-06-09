import 'package:flutter/material.dart';
import './screens/login.dart';

// Inicio do app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Estrutura principal
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(
          secondary: Colors.purple
        ),
      ),
      // parâmetro home que retorna a tela de login
      home: const LoginView(),
    );
  }
}
