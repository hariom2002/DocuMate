import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wordonline/providers/user_provider.dart';
import 'package:wordonline/repository/auth_repository.dart';
import 'package:wordonline/routes.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool? isPresent;
  void getUserData() async {
    isPresent =
        await ref.read(authRepositoryProvider).getUserDataWithToken(ref);
    setState(() {});
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
  debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final user = ref.watch(userProvider);
          if (user.token.isNotEmpty) return loggedInRoute;
          return loggedOutRoute;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
      // home: const LoginScreen(),
    );
  }
}
// flutter run -d chrome --web-port 58872