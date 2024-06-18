// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:farmapp/global.dart' as global;

class Ref extends StatefulWidget {
  const Ref({super.key});

  @override
  State<Ref> createState() => _RefState();
}


class _RefState extends State<Ref>{
    var enviar;
    var recibido;
    String output = '';
    String longitud = '';
    String latitud = '';
    bool visible = false;
    @override 
    Widget build(BuildContext context){
      return SelectionArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 215, 248, 177),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Obtener Referencia Catastral",
              style: global.appBarTextStyle,
              ),
            backgroundColor: const Color.fromARGB(255, 9, 71, 40),
          ),
          body: Container(
            alignment: Alignment.center,
            child: 
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Introduce las coordenadas de tu parcela",
                      style: global.estiloTexto
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        label: const Text('Longitud'),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.map),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60)
                         ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.-]'))],
                      onChanged: (value){
                        longitud = value.replaceAll(',','.');
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      decoration: InputDecoration(
                        label: const Text('Latitud'),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.map),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60)
                         ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.-]'))],
                      onChanged: (value){
                        latitud = value.replaceAll(',','.');
                      },
                    ),
                    const SizedBox(height: 20),
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
                          style: global.buttonstyle,
                          onPressed: () async {
                            try{
                              var enviar = {'opcion': 2, 'longitud': longitud, 'latitud': latitud};
                              recibido = await llamada(enviar);
                              var decoded = jsonDecode(recibido);
                              if (decoded["funciona"]) {
                                setState(() {
                                  var referencia = decoded['referencia'].toString();
                                  output = "Tu referencia catastral es\n$referencia";
                                  visible = true;
                                });
                              }else{
                                Alert(
                                context: context,
                                style: global.alertStyle, 
                                title: "Error", 
                                desc: "Por favor, introduce unas coordenadas de España",
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
                            } catch(error){
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
                          },
                          child: const Text('Obtener'),
                        ),
                
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (visible) 
                      Text(
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