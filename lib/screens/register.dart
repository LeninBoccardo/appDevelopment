import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_app/screens/home.dart';
import '../firebase_options.dart';
import 'package:email_validator/email_validator.dart';

// Tela de registro para caso o usuário não possua uma conta
class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

// Estado da tela de registro
// OBS.: A tela de registro poderia ter sido compartilhada com a tela de login
// pois possuem muitas funcionalidades semelhantes. Porém para finds didáticos
// ambas foram separadas.
class _RegisterViewState extends State<RegisterView> {
  // Variáveis que armazenam email e senha do usuário
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Função que cria uma caixa de alerta personalizado através do parâmetro teste
  AlertDialog _customAlert(String text) {
    return AlertDialog(
      title: const Text('Alerta!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(text),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Função que realiza a chamada da caixa de alerta através de um evento "Futuro"
  Future<void> _showDialog(String type) async {
    // Variável que armazena os tipos de alerta e modifica a caixa de alerta
    // com base na escolha do usuário
    Map types = {
      'valid email': 'Um email valido deve ser inserido.',
      'already registered email': 'Email já cadastrado',
      'empty password': 'O campo de senha não pode ficar vazio.',
    };

    // Retorno que exibe a caixa de alerta personalizada (_customAlert)
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _customAlert(types[type].toString());
      },
    );
  }

  // Função que inicia as variáveis de eamil e senha
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // Função que finaliza as mesmas variáveis a partir do momento que não forem
  // mais necessárias (isso evita uso excessivo de memória)
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // Função principal (build) que retorna toda a estrutura da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[400],
      body: Center(
        // Container que contém as estruturas da tela
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(183, 199, 199, 199),
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ]),
          height: 600,
          margin: const EdgeInsets.symmetric(horizontal: 32.0),
          padding: const EdgeInsets.all(16.0),
          // Widget que inicializa o Firebase (backend)
          child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            // builder que "constrói" os widgets assim que a conexão com o
            // backend é estabelecida
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Epistemic',
                        style: TextStyle(
                          color: Colors.purple[900],
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // Campode inserção do email
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'E-mail',
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          color: Colors.purple[800],
                        ),
                      ),
                      // Campo de inserção da senha
                      TextField(
                        controller: _password,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: 'Senha',
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(
                          color: Colors.purple[800],
                        ),
                      ),
                      // Botão que realiza a validação de cadastro
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple[900],
                        ),
                        onPressed: () async {
                          // Variáveis que armazenam as informações dos campos
                          // de texto
                          final email = _email.text;
                          final password = _password.text;

                          // Variável que verifica se o email é valido ou não
                          final bool isValid = EmailValidator.validate(email);

                          // "if" que verifca a validação do email
                          if (isValid) {
                            // "if" que valida a da senha
                            if (password == '') {
                              // Alerta personalizado de senha vazia
                              _showDialog('empty password');
                            } else {
                              //
                              try {
                                // Aqui uma instância do FirebaseAuth é criada e
                                // tenta realizar o cadastro através das
                                // informações passadas anteriormente
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password)
                                    .then((value) {
                                  // Caso de certo o cadastro, o usuário vai para
                                  // a tela "Home"
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Home()),
                                  );
                                });
                                // Aqui o catch é responsável por "pegar" apenas
                                // exceções da instância de FirebaseAuth
                              } on FirebaseAuthException catch (e) {
                                // "if" que verifca se o email inserido já está
                                // sendo usado
                                if (e.code == 'email-already-in-use') {
                                  // Alerta personalizado de "email já cadastrado"
                                  _showDialog('already registered email');
                                }
                              }
                            }
                          } else {
                            // Alerta personalizado de "email inválido"
                            _showDialog('valid email');
                          }
                        },
                        child: const Text('Registrar'),
                      ),
                      // Botão que retorna para a tela de login
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple[900],
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Voltar'),
                      ),
                    ],
                  );
                default:
                  // Tela de loading que é apresentada até a conexão com o
                  // firebase ser estabelicida
                  return const Text('Loading...');
              }
            },
          ),
        ),
      ),
      // backgroundColor: Color.fromARGB(190, 153, 109, 186),
    );
  }
}
