// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:farmapp/llamada.dart';
import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Ruta extends StatefulWidget {
  const Ruta({super.key});

  @override
  State<Ruta> createState() => _RutaState();
}

class _RutaState extends State<Ruta> {
    List<String> listaVehiculo = ['Agrícola','Camión','Furgoneta','Turismo'];
    List<String> listaCombustibleA = ['Gasóleo'];
    List<String> listaCombustibleC = ['Gasóleo','Gasolina','Gas Natural'];
    List<String> listaCombustibleF = ['Gasóleo','Gasolina'];
    List<String> listaCombustibleT = ['Gasóleo','Gasolina','Gas Licuado','Gas Natural'];
    var inicial = "";
    var enviar;
    var recibido;
    String output = '';
    String longitud = '';
    String latitud = '';
    int viajes = 0;
    @override 
    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: global.colorFondo,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Ruta",
            style: global.appBarTextStyle,
          ),
          backgroundColor: global.colorAppBar
        ),
        body: Container(
          alignment: Alignment.center,
          child: 
            SizedBox(
             width: MediaQuery.of(context).size.width * 0.35,
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Selecciona tu tipo de vehículo y su combustible.\nIntroduce el número de viajes hasta tu parcela y la localización del garaje de tu vehículo",
                      style: global.estiloTexto,
                      textAlign: TextAlign.justify
                      ),
                      const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            label: const Text("Tipo Vehículo"),
                            initialSelection: global.tipos['vehiculo'],
                            dropdownMenuEntries: listaVehiculo.map<DropdownMenuEntry<String>>((String value){
                            return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                            onSelected: (item){
                              setState(() {
                                global.tipos['vehiculo'] = item!;
                                debugPrint(global.tipos['combustible']);
                              });
                            }
                          ),
                        ),
                    const SizedBox(height: 14),
                    if (global.tipos['vehiculo'] == "Agrícola")
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            label: const Text("Combustible"),
                            initialSelection: global.tipos['combustible'],
                            dropdownMenuEntries: listaCombustibleA.map<DropdownMenuEntry<String>>((String valueA){
                            return DropdownMenuEntry<String>(value: valueA, label: valueA);
                            }).toList(),
                            onSelected: (itemA){
                              setState(() {
                                global.tipos['combustible'] = itemA!;
                              });
                            }
                          ),
                        ),
                    if (global.tipos['vehiculo'] == "Camión") 
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            label: const Text("Combustible"),
                            initialSelection: inicial,
                            dropdownMenuEntries: listaCombustibleC.map<DropdownMenuEntry<String>>((String valueC){
                            return DropdownMenuEntry<String>(value: valueC, label: valueC);
                            }).toList(),
                            onSelected: (itemC){
                              setState(() {
                                global.tipos['combustible'] = itemC!;
                              });
                            }
                          ),
                        ),
                    if (global.tipos['vehiculo'] == "Furgoneta")
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            label: const Text("Combustible"),
                            initialSelection: global.tipos['combustible'],
                            dropdownMenuEntries: listaCombustibleF.map<DropdownMenuEntry<String>>((String valueF){
                            return DropdownMenuEntry<String>(value: valueF, label: valueF);
                            }).toList(),
                            onSelected: (itemF){
                              setState(() {
                                global.tipos['combustible'] = itemF!;
                              });
                            }
                          ),
                        ),
                    if (global.tipos['vehiculo'] == "Turismo")
                        Container(
                          decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: DropdownMenu<String>(
                            expandedInsets: EdgeInsets.zero,
                            label: const Text("Combustible"),
                            initialSelection: global.tipos['combustible'],
                            dropdownMenuEntries: listaCombustibleT.map<DropdownMenuEntry<String>>((String valueT){
                            return DropdownMenuEntry<String>(value: valueT, label: valueT);
                            }).toList(),
                            onSelected: (valueT){
                              setState(() {
                                global.tipos['combustible'] = valueT!;
                              });
                            }
                          ),
                        ),
                    const SizedBox(height: 14),
                    TextField(
                      decoration: InputDecoration(
                        label: const Text('Viajes'),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.numbers_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60)
                         ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value){
                        viajes = int.parse(value);
                      },
                    ),
                    const SizedBox(height: 14),
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
                            ()=>context.pop(),
                            child: const Text('Volver'),
                          ),
                          ElevatedButton(
                          style: global.buttonstyle,
                          onPressed: () async {
                            debugPrint(viajes.toString());
                            if ((global.tipos['vehiculo'] == "") | (global.tipos['combustible'] == "")) {
                                Alert(
                                context: context,
                                style: global.alertStyle, 
                                title: "Error", 
                                desc: "Por favor, selecciona un vehículo y su tipo de gasolina",
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
                            } else if((viajes.isNegative) | (viajes == 0)){
                              Alert(
                                context: context,
                                style: global.alertStyle, 
                                title: "Error", 
                                desc: "Por favor, introduce una cantidad positiva entera distinta de 0 en los viajes",
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
                                var enviar = {'opcion': 6, 'viajes': viajes, 'longitud': longitud, 'latitud': latitud, 'vehiculo': global.tipos['vehiculo'], 'combustible': global.tipos['combustible'], 'referencia': global.datosGranja['referencia']};
                                recibido = await llamada(enviar);
                                var decoded = jsonDecode(recibido);
                              if (decoded["funciona"]) {
                                setState(() {
                                  global.resultadoFinal['ruta'] = decoded['cantidad'];
                                  global.mapa['mapa'] = decoded['mapa'];
                                });
                                if (global.rutador['fertilizante']!) {
                                  context.push("/fertilizante");
                                }else{
                                  if (global.rutador['abono']!) {
                                    context.push("/abono");
                                  }else {
                                    context.push("/resultados");
                                  }
                                }
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
                              } catch (error){
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