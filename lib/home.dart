import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmapp/global.dart' as global;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 248, 177),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Farmapp",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
            backgroundColor: const Color.fromARGB(255, 9, 71, 40),
          ),
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text (
                'Bienvenido a FarmApp',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 35),
              Text("Seleccione una de estas opciones",
                      style: global.estiloTexto
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: global.homebuttonstyle,
                    onPressed: ()=>context.go("/coordenadas"),
                    child: const Text('Obtener Coordenadas'),
                  ),
                  ElevatedButton(
                    style: global.homebuttonstyle,
                    onPressed: ()=>context.go("/referencia"),
                    child: const Text('Obtener Referencia Catastral'),
                  ),
                  ElevatedButton(
                    style: global.homebuttonstyle,
                    onPressed: ()=>context.go("/huella"),
                    child: const Text('Calcular Huella'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}





            