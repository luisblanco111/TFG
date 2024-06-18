library global;


import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var datosGranja = {'provincia': "", 'municipio': "", 'referencia': ""};
var tipos = {'cultivo': "",'fertilizante': "",'abono1': "",'abono2': "",'vehiculo':"",'combustible':""};
Map<String,double> cantidad= {'cultivo': 0, 'fertilizante': 0, 'abono': 0};
Map<String,double> resultadoFinal = {'cultivo': 0,'fertilizante': 0,'abono': 0,'ruta': 0};
var rutador = {'fertilizante': false,'abono': false,'ruta': false};
Map<String,String> mapa = {'mapa': ""};

var alertStyle = AlertStyle(
        animationType: AnimationType.fromBottom,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: const TextStyle(fontWeight: FontWeight.bold),
        animationDuration: const Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: const TextStyle(
          color: Colors.red,
          fontSize: 40,
          fontWeight: FontWeight.w800
        ),
        overlayColor: const Color(0x55000000),
        alertAlignment: Alignment.center,);

var buttonstyle = ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 9, 71, 40),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      );

var homebuttonstyle = ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 9, 71, 40),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold
        ),
      );

var appBarTextStyle = const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              );

var colorFondo = const Color.fromARGB(255, 215, 248, 177);
var colorAppBar = const Color.fromARGB(255, 9, 71, 40);

var estiloTexto = const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                            );