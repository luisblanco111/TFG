// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Fertilizante extends StatefulWidget {
  const Fertilizante({super.key});

  @override
  State<Fertilizante> createState() => _FertilizanteState();
}

class _FertilizanteState extends State<Fertilizante> {
  List<String> lista1 = ['Nitrato amónico','Nitrato de calcio','Nitrato de magnesio','Nitrato potásico','Sulfato amónico','Urea'];
  String? fertilizante;
  var enviar;
  var recibido;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Fertilizante",
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
                  Text("Selecciona tu tipo de fertilizante e introduce la cantidad que utilizas en kilogramos",
                      style: global.estiloTexto,
                       textAlign: TextAlign.justify
                      ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Tipo Fertilizante"),
                      initialSelection: global.tipos['fertilizante'],
                      dropdownMenuEntries: lista1.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['fertilizante'] = item!;
                        });
                      }
                    ),
                  ),
                  const SizedBox(height: 14),
                    TextField(
                          decoration: InputDecoration(
                            label: const Text('Cantidad'),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(Icons.monitor_weight_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60)
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.-]'))],
                          onChanged: (value){
                            global.cantidad['fertilizante'] =double.parse(value.replaceAll(',','.'));
                          },
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
                          if (global.tipos['fertilizante'] == "" ) {
                              Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, selecciona un tipo de fertilizante",
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
                          } else if( global.cantidad['fertilizante']!.isNaN | (global.cantidad['fertilizante']! == 0)){
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
                              var enviar = {'opcion': 4,'fertilizante': global.tipos['fertilizante'], 'cantidad': global.cantidad['fertilizante'],'provincia': global.datosGranja['provincia']};
                              recibido = await llamada(enviar);
                              var decoded = jsonDecode(recibido);
                              setState(() {
                                global.resultadoFinal['fertilizante'] = decoded['cantidad'];
                              });
                              if (global.rutador['abono']!) {
                                context.push("/abono");
                              }
                              else {
                                context.push("/resultados");
                              }
                            }
                            catch (error){
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