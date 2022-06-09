import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:learning_app/screens/forgot_password.dart';
import 'package:learning_app/screens/home.dart';
import 'package:learning_app/screens/register.dart';
import 'package:learning_app/screens/terms_of_use.dart';
import 'package:email_validator/email_validator.dart';

// Tela de login
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Estado da tela de login
class _LoginViewState extends State<LoginView> {
  // Variáveis que armazenam email e senha do usuário
  @override
  late final TextEditingController _email;
  late final TextEditingController _password;
  // Variavél que a habilita ou não os campos de inserção de email e senha
  bool _textInputEnable = true;
  // Variável para contagem da quantidade de vezes que o usuário inseriu a senha
  // incorretamente
  int _wrongPasswordCounter = 1;

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
  Future<void> _showMyDialog(String type) async {
    // Variável que armazena os tipos de alerta e modifica a caixa de alerta
    // com base na escolha do usuário
    Map types = {
      'valid email': 'Um email valido deve ser inserido.',
      'recover email': 'Insira seu email para recuperação',
      'not registered email': 'Email não registrado',
      'password empty': 'O campo de senha não pode ficar vazio.',
      'password block':
          'A senha foi inserida incorretamente 3 vezes e seu acesso foi bloqueado!\nTente recupera-lá pelo botão "Esqueceu a senha?" ou crie uma nova conta.'
    };

    // Retorno que exibe a caixa de alerta personalizada (_customAlert)
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return _customAlert(types[type].toString());
      },
    );
  }

  // Função que controal e registra o número de vezes que o usuário digitou a
  // senha incorretamente
  void wrongPasswordHandler() {
    // Teste que verifica se a contagem já está em três
    if (_wrongPasswordCounter == 3) {
      // Caso esteja, a função setState limpa os campos de inserção (textField)
      // e os desabilita
      setState(() {
        _email.clear();
        _password.clear();
        _textInputEnable = false;
      });
      // Alerta personalizado é mostrado
      _showMyDialog('password block');
    } else {
      // setState incrementa o contador de senhas digitadas incorretamente
      setState(() {
        _wrongPasswordCounter++;
      });
    }
  }

  // Função que reseta o contador
  void wrongPasswordReset() {
    setState(() {
      _wrongPasswordCounter = 1;
    });
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
                        autofocus: false,
                        enabled: _textInputEnable,
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
                        autofocus: false,
                        enabled: _textInputEnable,
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
                      // Botão que realiza a validação de login
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
                          final bool isValidEmail =
                              EmailValidator.validate(email);

                          // "if" que verifica se os campos contém alguma
                          // informação
                          if (!isValidEmail) {
                            _showMyDialog('valid email');
                          } else if (password == '') {
                            _showMyDialog('password empty');
                          } else {
                            // try-catch usado para "sign in" no banco de dados
                            try {
                              // Aqui uma instância do FirebaseAuth é criada e
                              // tenta realizar o login através das informações
                              // passadas anteriormente
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password)
                                  .then((value) {
                                // Caso de certo o login, o usuário vai para
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
                              switch (e.code) {
                                // Caso a exceção seja de senha incorreta, a
                                // função de controle da variável de contagem
                                // de senhas incorretas é chamada
                                case 'wrong-password':
                                  wrongPasswordHandler();
                                  break;
                                // Caso seja de usuário não encontrado, um alerta
                                // personalizado informando tal erro é chamado
                                case 'user-not-found':
                                  _showMyDialog('not registered email');
                                  break;
                              }
                            }
                          }
                        },
                        child: const Text('Entrar'),
                      ),
                      // TextButton usado para recuperação da senha
                      TextButton(
                        onPressed: () {
                          // Variável que armazena o email do campo de texto
                          String email = _email.text;
                          // Variável que valida o email
                          final bool isValidEmail =
                              EmailValidator.validate(email);

                          // "if" que verifica se o campo está ou não habilitado,
                          // caso não esteja, setState o habilita
                          if (!_textInputEnable) {
                            setState(() {
                              _textInputEnable = true;
                            });
                            // Alerta personalizado que informa sobre a
                            // recuperação do email
                            _showMyDialog('recover email');
                            // "else if" que verifica se o email é válido
                          } else if (isValidEmail) {
                            // caso seja, a contagem de senhas inseridas
                            // incorretamente é resetada e o usuário é levado
                            // a tela de "esqueci minha senha".
                            wrongPasswordReset();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword(
                                        email: email,
                                      )),
                            );
                          } else {
                            // Alerta para informar que um email valido deve ser
                            // inserido
                            _showMyDialog('valid email');
                          }
                        },
                        child: Text(
                          'Esqueceu a senha? Clique Aqui',
                          style: TextStyle(
                            color: Colors.purple[900],
                          ),
                        ),
                      ),
                      // TextButton usado para acessar um novo cadastro
                      TextButton(
                        onPressed: () {
                          // Ao clicar no botão o usuário é levado a tela de 
                          // cadastro
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterView()),
                          );
                        },
                        child: Text(
                          'Não tem uma conta? Cadastre-se',
                          style: TextStyle(
                            color: Colors.purple[900],
                          ),
                        ),
                      ),
                      // TextButton usado para acessar os termos de uso
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TermsOfUse()),
                          );
                        },
                        child: Text(
                          'Termos de uso',
                          style: TextStyle(
                            color: Colors.purple[900],
                          ),
                        ),
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
