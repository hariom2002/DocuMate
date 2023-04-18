import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordonline/colors.dart';
import 'package:wordonline/common/widgets/Loader.dart';
import 'package:wordonline/constants.dart';
import 'package:wordonline/models/document_model.dart';
import 'package:wordonline/providers/user_provider.dart';
import 'package:wordonline/repository/document_repository.dart';
import 'package:wordonline/repository/socket_repository.dart';

import '../models/Error_model.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: "Untitled Document");
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initialFunctions());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void initialFunctions() {
    socketRepository.joinRoom(widget.id);
    fetchDocumentsData();

    socketRepository.changeListner((data) => _controller?.compose(
        quill.Delta.fromJson(data['delta']),
        _controller?.selection ?? const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.REMOTE));

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void fetchDocumentsData() async {
    errorModel = await ref
        .read(DocumentRepositoryProvider)
        .getDocumentByid(id: widget.id, token: ref.watch(userProvider).token);
    customPrint("came here at fetchDocumentData");
    if (errorModel!.data != null) {
      customPrint((errorModel!.data as DocumentModel).title);
      titleController.text = (errorModel!.data as DocumentModel).title;
      _controller = quill.QuillController(
          document: (errorModel!.data as DocumentModel).content.isEmpty
              ? quill.Document()
              : quill.Document.fromJson(
                  (errorModel!.data as DocumentModel).content),
          selection: const TextSelection.collapsed(offset: 0));
      setState(() {});
    }
    _controller!.document.changes.listen((event) {
      // 1-> entire content
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {'delta': event.item2, 'room': widget.id};
        socketRepository.typing(map);
      }
    });
  }

  Future<void> updateTitle(WidgetRef ref, String titleparamenter) async {
    await ref.watch(DocumentRepositoryProvider).updateDocumentTitle(
        token: ref.watch(userProvider).token,
        id: widget.id,
        title: titleparamenter);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        actions: [
          Container(
            // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: kblueColor),
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                  color: kWhiteColor,
                ),
                label: const Text('Share')),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/docs-logo.png',
                height: 40,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kblueColor)),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: kgreyColor, width: 0.1)),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            quill.QuillToolbar.basic(controller: _controller!),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                width: 750,
                child: Card(
                  elevation: 5,
                  color: kWhiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller!,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
