import 'package:farmapp/coor.dart';
import 'package:farmapp/cultivos.dart';
import 'package:farmapp/abono.dart';
import 'package:farmapp/fertilizante.dart';
import 'package:farmapp/home.dart';
import 'package:farmapp/huella.dart';
import 'package:farmapp/ruta.dart';
import 'package:farmapp/referencia.dart';
import 'package:farmapp/resultados.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter (routes: <GoRoute>[
  GoRoute(path: '/', builder: (BuildContext context, GoRouterState state){
    return const Home();
  }),
  GoRoute(path: '/coordenadas', builder: (BuildContext context, GoRouterState state){
    return const Coor();
  }),
  GoRoute(path: '/referencia', builder: (BuildContext context, GoRouterState state){
    return const Ref();
  }),
  GoRoute(
    path: '/huella',
     builder: (BuildContext context, GoRouterState state){
        return const Huella();
   }),
  GoRoute(
    path: '/cultivos',
      builder: (BuildContext context, GoRouterState state){
        return const Cultivos();
      }
  ),
  GoRoute(
    path: '/ruta',
     builder: (BuildContext context, GoRouterState state){
        return const Ruta();
   }),
  GoRoute(
    path: '/fertilizante',
      builder: (BuildContext context, GoRouterState state){
        return const Fertilizante();
      }
  ),
  GoRoute(
    path: '/abono',
      builder: (BuildContext context, GoRouterState state){
        return const Abono();
      }
  ),
  GoRoute(
    path: '/resultados',
      builder: (BuildContext context, GoRouterState state){
        return const Resultados();
      }
  ),
]);