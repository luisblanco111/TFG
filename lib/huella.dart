// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class Huella extends StatefulWidget {
  const Huella({super.key});

  @override
  State<Huella> createState() => _HuellaState();
}

class _HuellaState extends State<Huella> {
  var enviar;
  var recibido;
  List<String> lista = ["Albacete","Alicante","Almería","Álava","Asturias","Ávila","Badajoz","Baleares","Barcelona","Bizkaia","Burgos","Cáceres","Cádiz","Cantabria","Castellón","Ciudad Real","Córdoba","A Coruña","Cuenca","Gipúzkoa","Girona","Granada","Guadalajara","Huelva","Huesca","Jaén","León","Lleida","Lugo","Madrid","Málaga","Murcia","Navarra","Ourense","Palencia","Las Palmas","Pontevedra","La Rioja","Salamanca","Santa Cruz de Tenerife","Segovia","Sevilla","Soria","Tarragona","Teruel","Toledo","Valencia","Valladolid","Zamora","Zaragoza","Ceuta","Melilla"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Huella de Carbono",
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
                  Text("Introduce tu referencia catastral y selecciona tu provincia y tus opciones",
                      style: global.estiloTexto
                    ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: DropdownMenu<String>(
                        expandedInsets: EdgeInsets.zero,
                        label: const Text("Provincia"),
                        initialSelection: global.datosGranja['provincia'],
                        dropdownMenuEntries: lista.map<DropdownMenuEntry<String>>((String value){
                          return DropdownMenuEntry<String>(value: value, label: value);
                        }).toList(),
                        onSelected: (item){
                        setState(() {
                          global.datosGranja['provincia'] = item!;
                            });
                          }
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom :15.0),
                    child: TextField(
                      decoration: InputDecoration(
                        label: const Text('Referencia catastral'),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.map),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60)
                         ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                      onChanged: (value){
                        global.datosGranja['referencia'] = value;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Utilizas fertilizante en tu granja?"),
                      Checkbox(
                        activeColor: global.colorAppBar,
                        value: global.rutador['fertilizante'],
                        onChanged: (bool? value) {
                          setState(() {
                          global.rutador['fertilizante'] = value!;
                         });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("¿Utilizas abono en tu granja?"),
                      Checkbox(
                        activeColor: global.colorAppBar,
                        value: global.rutador['abono'],
                        onChanged: (bool? value) {
                          setState(() {
                          global.rutador['abono'] = value!;
                         });
                        },
                      )
                    ],
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
                          if (global.datosGranja['provincia'] == "" ) {
                              Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, selecciona una provincia",
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
                          } else if (global.datosGranja['referencia']!.length != 14) {
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
                          } 
                          else{
                            try{
                              var enviar = {'opcion': 7,'referencia': global.datosGranja['referencia']};
                              recibido = await llamada(enviar);
                              var decoded = jsonDecode(recibido);
                              if (decoded["funciona"]) {
                                context.push("/cultivos");
                              }else{
                                Alert(
                                  context: context,
                                  style: global.alertStyle, 
                                  title: "Error", 
                                  desc: "No hay ninguna parcela asociada a esa Referencia",
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
                        }
                      },
                        child:  const Text('Siguiente'),
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