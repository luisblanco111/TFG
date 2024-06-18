// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cultivos extends StatefulWidget {
  const Cultivos({super.key});

  @override
  State<Cultivos> createState() => _CultivosState();
}

class _CultivosState extends State<Cultivos> {
  List<String> lista1 = ['Almendro','Arroz','Avena','Cebada','Girasol','Hortalizas','Leguminosas','Maíz','Trigo','Tubérculos','Viñedo',];
  String? cultivo;
  var enviar;
  var recibido;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Cultivos",
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
                  Text("Selecciona tu tipo de cultivo e introduce la cantidad que siembras en kilogramos",
                      style: global.estiloTexto
                    ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Cultivo"),
                      initialSelection: global.tipos['cultivo'],
                      dropdownMenuEntries: lista1.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['cultivo'] = item!;
                        });
                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom :15.0),
                    child: TextField(
                        decoration: InputDecoration(
                          label: const Text('Cantidad'),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.monitor_weight_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60)
                           ),
                        ),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
                        onChanged: (value){
                          global.cantidad['cultivo'] = double.parse(value.replaceAll(',','.'));
                        },
                      ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: global.buttonstyle,
                        onPressed:
                          ()=>context.pop(),
                        child: const Text('Volver'),
                      ),
                      ElevatedButton(
                        style: global.buttonstyle,
                        onPressed: () async {
                          if (global.tipos['cultivo'] == "" ) {
                              Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, selecciona un cultivo",
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
                          } else if(global.cantidad['cultivo']!.isNaN | (global.cantidad['cultivo']! == 0)){
                            Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, introduce una cantidad positiva distinta de 0",
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
                              var enviar = {'opcion': 3, 'provincia': global.datosGranja['provincia'], 'municipio': global.datosGranja['municipio'], 'referencia': global.datosGranja['referencia'], 'tipo': global.tipos['cultivo'], 'cantidad': global.cantidad['cultivo']};
                              recibido = await llamada(enviar);
                              var decoded = jsonDecode(recibido);
                              setState(() {
                                global.resultadoFinal['cultivo'] = decoded['cantidad'];
                              });
                              context.push("/ruta");
                              }
                              catch(error){
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
                        child: const Text('Siguiente'),
                      ),
                    ],
                  ),
                ],
              ),
            ), 
        )
      );
  }
}