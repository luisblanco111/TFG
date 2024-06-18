// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:farmapp/global.dart' as global;

class Coor extends StatefulWidget {
  const Coor({super.key});

  @override
  State<Coor> createState() => _CoorState();
}

class _CoorState extends State<Coor> {
    var enviar;
    var recibido;
    String output = '';
    String municipio = '';
    String provincia = '';
    String referencia = '';
    bool visible = false;
    @override 
    Widget build(BuildContext context){
      return SelectionArea(
        child: Scaffold(
          backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Obtener Coordenadas",
              style: global.appBarTextStyle,
            ),
            backgroundColor: global.colorAppBar
          ),
          body: Container(
            alignment: Alignment.center,
            child: 
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Introduce las referencia catastral de tu parcela",
                          style: global.estiloTexto
                          ),
                        const SizedBox(height: 20),
                        TextField(
                          decoration: InputDecoration(
                            label: const Text('Referencia'),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.map),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 0.0,
                              ),
                              borderRadius: BorderRadius.circular(60)
                             ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                          onChanged: (value){
                            referencia = value;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: global.buttonstyle,
                          onPressed:
                            ()=>context.go("/"),
                          child: const Text('Volver'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (referencia.length != 14) {
                              Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, introduce una referencia de 14 caracteres",
                              buttons: [
                                DialogButton(
                                  onPressed: () => Navigator.pop(context),
                                  width: 120,
                                  child: const Text(
                                    "Volver",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ],
                            ).show();
                          } else{
                              try{
                                var enviar = {'opcion': 1, 'provincia': provincia, 'municipio': municipio, 'referencia': referencia};
                                recibido = await llamada(enviar);
                                var decoded = jsonDecode(recibido);
                                if (decoded["funciona"]) {
                                  setState(() {
                                    var longitud = decoded['longitud'].toString();
                                    var latitud = decoded['latitud'].toString();
                                    output = "Tus coordenadas son: \nLongitud: $longitud \nLatitud:    $latitud";
                                    visible = true;
                                  });
                                }else{
                                  Alert(
                                  context: context,
                                  style: global.alertStyle, 
                                  title: "Error", 
                                  desc: "Referencia incorrecta",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                      child: const Text(
                                        "Volver",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ],
                                  ).show();
                                }
                            }catch(error){
                              Alert(
                                  context: context,
                                  style: global.alertStyle, 
                                  title: "Error", 
                                  desc: "No hay conexión con el servidor",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      width: 120,
                                      child: const Text(
                                        "Volver",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ],
                                ).show();
                              }
                            }
                          },
                          style: global.buttonstyle,
                          child: const Text('Obtener'),

                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (visible)Text(
                        output,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                  
                ),
              ), 
          )
        ),
      );
    }
}