import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:wordonline/colors.dart';
import 'package:wordonline/common/widgets/Loader.dart';
import 'package:wordonline/models/document_model.dart';
import 'package:wordonline/providers/user_provider.dart';
import 'package:wordonline/repository/auth_repository.dart';

import '../models/Error_model.dart';
import '../repository/document_repository.dart';

class HomePage extends ConsumerWidget {
  void navigateToDocumentScreen(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  void createDocuments(WidgetRef ref, BuildContext context) async {
    String token = ref.watch(userProvider).token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);
    final ErrorModel errorModel =
        await ref.watch(DocumentRepositoryProvider).createDocuments(token);

    if (errorModel.error == null) {
      navigator.replace('/document/${errorModel.data.id}');
    } else {
      print(errorModel.error!);
      snackbar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => createDocuments(ref, context),
            icon: const Icon(Icons.add),
            color: kredColor,
          ),
          IconButton(
            onPressed: () =>
                ref.watch(authRepositoryProvider).signOut(ref, context),
            icon: const Icon(Icons.logout),
            color: kredColor,
          )
        ],
      ),
      body: FutureBuilder<ErrorModel>(
        future: ref
            .watch(DocumentRepositoryProvider)
            .getDocumentsforHomePage(ref.watch(userProvider).token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 600,
              child: ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];
                  return InkWell(
                    onTap: () => navigateToDocumentScreen(context, document.id),
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(document.title,
                              style: const TextStyle(fontSize: 17)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
