import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_manage_tut/core/navigation/app_router.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Text("It is working");
  }
}
