// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Abono extends StatefulWidget {
  const Abono({super.key});

  @override
  State<Abono> createState() => _AbonoState();
}

class _AbonoState extends State<Abono> {
  List<String> lista = ['Estiércol sólido','Estiércol semilíquido','Purín'];
  List<String> listaES = ['Avícola', 'Caprino','Cunícola','Ovino', 'Porcino', 'Vacuno'];
  List<String> listaEL = ['Avícola', 'Cunícola', 'Porcino', 'Vacuno'];
  List<String> listaP = ['Porcino', 'Vacuno'];
  String? abono;
  var enviar;
  var recibido;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Abono",
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
                  Text("Selecciona tu tipo de abono y su origen e introduce la cantidad que utilizas en kilogramos",
                      style: global.estiloTexto,
                       textAlign: TextAlign.justify
                      ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Tipo Abono"),
                      initialSelection: global.tipos['abono1'],
                      dropdownMenuEntries: lista.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['abono1'] = item!;
                        });
                      }
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (global.tipos['abono1'] == "Estiércol sólido")
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Origen Abono"),
                      initialSelection: global.tipos['abono2'],
                      dropdownMenuEntries: listaES.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['abono2'] = item!;
                        });
                      }
                    ),
                  ),
                  if (global.tipos['abono1'] == "Estiércol semilíquido")
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Origen Abono"),
                      initialSelection: global.tipos['abono2'],
                      dropdownMenuEntries: listaEL.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['abono2'] = item!;
                        });
                      }
                    ),
                  ),
                  if (global.tipos['abono1'] == "Purín")
                  Container(
                    decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: DropdownMenu<String>(
                      expandedInsets: EdgeInsets.zero,
                      label: const Text("Origen Abono"),
                      initialSelection: global.tipos['abono2'],
                      dropdownMenuEntries: listaP.map<DropdownMenuEntry<String>>((String value){
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                      onSelected: (item){
                        setState(() {
                          global.tipos['abono2'] = item!;
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
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]'))],
                      onChanged: (value){
                        global.cantidad['abono'] =double.parse(value.replaceAll(',','.'));
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
                          if ((global.tipos['abono1'] == "") | (global.tipos['abono2'] == "")) {
                              Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, selecciona un tipo primario y secundario de abono",
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
                          } else if( global.cantidad['abono']!.isNaN | (global.cantidad['abono']! == 0)){
                            Alert(
                              context: context,
                              style: global.alertStyle, 
                              title: "Error", 
                              desc: "Por favor, introduce una cantidad distinta de 0",
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
                              var enviar = {'opcion': 5,'abono1': global.tipos['abono1'],'abono2': global.tipos['abono2'], 'cantidad': global.cantidad['abono'],'provincia': global.datosGranja['provincia']};
                              recibido = await llamada(enviar);
                              var decoded = jsonDecode(recibido);
                              setState(() {
                                global.resultadoFinal['abono'] = decoded['cantidad'];
                              });
                              context.push("/resultados");
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