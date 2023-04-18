import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordonline/colors.dart';
import 'package:wordonline/repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});
  void signInWithGoogle(WidgetRef ref, BuildContext context)async{
    await ref.watch(authRepositoryProvider).signInWithGoogle(ref, context);

  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            "sign in with google",
            style: TextStyle(color: kblackColor),
          ),
          style: ElevatedButton.styleFrom(
            
              backgroundColor: kWhiteColor, minimumSize: const Size(150, 50)),
        ),
      ),
    );
  }
}
