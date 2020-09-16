import 'dart:convert';

import 'package:elpromediadorapp/models/consolidado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static const routeName = '/';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final codigoTextController = TextEditingController(text: '');
  final contrasenaTextController = TextEditingController(text: '');
  final codigoFocusNode = FocusNode();
  final contrasenaFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/fondo_login.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black12.withOpacity(0.7),
                BlendMode.srcATop,
              ),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'El Promediador',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 250,
                        child: buildWhiteTextField(
                            'Código UPC',
                            codigoTextController,
                            TextInputAction.next,
                            codigoFocusNode,
                            nextFocusNode: contrasenaFocusNode),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 250,
                        child: buildWhiteTextField(
                            'Contraseña',
                            contrasenaTextController,
                            TextInputAction.go,
                            contrasenaFocusNode,
                            password: true,
                            goFunction: obtenerNotas),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: RaisedButton(
                        onPressed: obtenerNotas,
                        child: Text(
                          'OBTENER NOTAS',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'BICASTUDIOS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void obtenerNotas() {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = codigoTextController.text;
    data['contrasena'] = contrasenaTextController.text;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Obteniendo notas'),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder<String>(
                  // future: Future.delayed(
                  //   const Duration(seconds: 1),
                  //   () => DefaultAssetBundle.of(context)
                  //       .loadString('assets/data/debug.json'),
                  future: http
                      .post(
                    'https://www.elpromediador.ga/notas',
                    body: data,
                  )
                      .then((response) {
                    var decoded = json.decode(response.body);
                    if (decoded['consolidado'] != null) {
                      Consolidado consolidado =
                          Consolidado.fromJson(decoded['consolidado']);
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/notas',
                          arguments: consolidado);
                    } else {
                      throw Exception();
                    }
                    return;
                  }),
                  builder: (context, snapshot) {
                    print(snapshot);
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          Text(
                            'Oops...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Divider(),
                          Text(
                            'No se pudo acceder ni obtener las notas de SOCRATES UPC',
                          ),
                          Divider(),
                          Text(
                            'Revisa tus datos y la disponibilidad de SOCRATES UPC. Luego vuelve a intentarlo.',
                          ),
                          Divider(),
                          Text(
                            'Si el problema persiste, agradecería que me notifiques de este error enviando tu codigo UPC '
                            'y la hora aproximada de tu consulta en un correo a edarbieto@gmail.com',
                          ),
                          Divider(),
                          Text(
                            'NOTA: No olvides que luego de 3 intentos fallidos de acceso a los servicios de la UPC, '
                            'se bloqueará tu cuenta. No es responsabilidad de esta página, ya que solo es un puente al '
                            'mismo SOCRATES UPC.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Text('CANCELAR'),
                  onPressed: () {
                    Navigator.of(context).pop('cancelado');
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildWhiteTextField(String label, TextEditingController controller,
      TextInputAction action, FocusNode focusNode,
      {bool password = false, FocusNode nextFocusNode, Function goFunction}) {
    return TextField(
      maxLines: 1,
      textInputAction: action,
      onSubmitted: (_) {
        if (action == TextInputAction.next) {
          focusNode.unfocus();
          FocusScope.of(context).requestFocus(nextFocusNode);
        } else if (action == TextInputAction.go) {
          goFunction();
        }
      },
      focusNode: focusNode,
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: password,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 10,
        ),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        isDense: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
