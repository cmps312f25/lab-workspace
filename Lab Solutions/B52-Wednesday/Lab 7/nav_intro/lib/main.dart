import 'package:flutter/material.dart';
import 'package:nav_intro/core/navigation/app_router.dart';
import 'package:nav_intro/presentation/pages/page_1.dart';

void main() {
  runApp(MaterialApp.router(
    routerConfig: AppRouter.router,
  ));
}
