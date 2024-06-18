import 'package:farmapp/routes.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(
    const FarmApp()
    );
}


class FarmApp extends StatelessWidget{
  const FarmApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      title: "FarmApp",
      routerConfig: router,
    );
  }
}