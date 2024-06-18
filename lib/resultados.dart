import 'package:flutter/material.dart';
import 'package:farmapp/global.dart' as global;
import 'package:go_router/go_router.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:restart_app/restart_app.dart';

class Resultados extends StatefulWidget {
  const Resultados({super.key});

  @override
  State<Resultados> createState() => _ResultadosState();
}

class _ResultadosState extends State<Resultados> {
  String cultivo = global.resultadoFinal['cultivo']!.toString().replaceAll('.',',');
  String ruta = global.resultadoFinal['ruta']!.toString().replaceAll('.',',');
  String fertilizante = global.resultadoFinal['fertilizante']!.toString().replaceAll('.',',');
  String abono = global.resultadoFinal['abono']!.toString().replaceAll('.',',');
  Map<String, double> dataMap = {
    "Cultivo": global.resultadoFinal['cultivo']!,
    "Ruta": global.resultadoFinal['ruta']!,
    "Fertilizante": global.resultadoFinal['fertilizante']!,
    "Abono": global.resultadoFinal['abono']!,
  };
  var total = (global.resultadoFinal['cultivo']!+global.resultadoFinal['fertilizante']!+global.resultadoFinal['abono']!+global.resultadoFinal['ruta']!).toStringAsFixed(2).replaceAll('.',',');
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
          backgroundColor: global.colorFondo,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text("Resultados",
              style: global.appBarTextStyle,
            ),
            backgroundColor: global.colorAppBar
          ),
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                  child: 
                  SizedBox(
                    width: MediaQuery.of(context).size.width  * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14),
                        const Text(
                          "Tu ruta óptima es esta:",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline
                          )),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: MediaQuery.of(context).size.width  * 0.5,
                          height: MediaQuery.of(context).size.height  * 0.5,
                          child: Image(
                            image: NetworkImage(global.mapa['mapa']!),
                            fit: BoxFit.fill
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                          "Resultados",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline
                          )),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width  * 0.30,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.black),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText.rich(
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                        TextSpan(
                                          text:"CO2 procedente de tu cultivo: ",
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "$cultivo tCO2eq",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]
                                        )
                                      ),
                                    Text.rich(
                                      textAlign: TextAlign.justify,
                                        TextSpan(
                                          style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                          text:"CO2 procedente de tu ruta: ",
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "$ruta tCO2eq",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]
                                        )
                                      ),
                                    if (global.rutador['fertilizante']!)
                                      Text.rich(
                                        style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                        TextSpan(
                                          text:"CO2 procedente de tu fertilizante: ",
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "$fertilizante tCO2eq",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]
                                        )
                                      ),
                                     if (global.rutador['abono']!)
                                     Text.rich(
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                        TextSpan(
                                          text:"CO2 procedente de tu abono: ",
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "$abono tCO2eq",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]
                                        )
                                      ),
                                    const SizedBox(height: 14),
                                    Text.rich(
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.start,
                                      TextSpan(
                                        text:"Total emisiones:  ",
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: "$total tCO2eq",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ]
                                      )
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 35),
                            PieChart(
                              dataMap: dataMap,
                              animationDuration: const Duration(milliseconds: 800),
                              chartLegendSpacing: 32,
                              chartRadius: MediaQuery.of(context).size.width / 10,
                              initialAngleInDegree: 0,
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValueBackground: true,
                                showChartValues: true,
                                showChartValuesInPercentage: true,
                                showChartValuesOutside: false,
                                decimalPlaces: 1,
                              ),
                            ) 
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width  * 0.45,
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: global.buttonstyle,
                              onPressed:
                                ()=>context.pop(),
                              child: const Text('Atrás'),
                            ),
                            ElevatedButton(
                              style: global.buttonstyle,
                              onPressed:(){
                                global.tipos = {'cultivo': "",'fertilizante': "",'abono1': "",'abono2': ""};
                                global.cantidad= {'cultivo': 0, 'fertilizante': 0, 'abono': 0};
                                global.resultadoFinal = {'cultivo': 0,'fertilizante': 0,'abono': 0,'ruta': 0};
                                global.rutador = {'fertilizante': false,'abono': false,'ruta': false};
                                Restart.restartApp();
                              },
                              child: const Text('Ir a inicio'),
                            ),
                          ],
                                                ),
                        ),
                      const SizedBox(height: 30),
                      ],
                    ),
                  ),
              ),
            )
      ),
    );
  }
}