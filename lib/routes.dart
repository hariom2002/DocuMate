import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wordonline/screens/document_screen.dart';
import 'package:wordonline/screens/home_screen.dart';
import 'package:wordonline/screens/login_screen.dart';

final loggedOutRoute = RouteMap(
    routes: {'/': (route) => const MaterialPage(child: LoginScreen())});

final loggedInRoute = RouteMap(
    routes: {'/': (route) => const MaterialPage(child: HomePage()),
    '/document/:id': (route) => MaterialPage(child: DocumentScreen(id: route.pathParameters['id']??' '))});