// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:wordonline/constants.dart';
import 'package:wordonline/models/Error_model.dart';
import 'package:wordonline/models/document_model.dart';

// ignore: non_constant_identifier_names
final DocumentRepositoryProvider = Provider(
  (ref) => DocumentRepository(
    client: Client(),
  ),
);

class DocumentRepository {
  final Client _client;
  DocumentRepository({
    required Client client,
  }) : _client = client;

  Future<ErrorModel> createDocuments(String token) async {
    ErrorModel errorModel = ErrorModel(error: "Some Error ocurred", data: null);
    try {
      Response res = await _client.post(Uri.parse('$host/doc/create'),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            tokenKey: token
          },
          body: jsonEncode({
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          }));
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          print(errorModel.data);
          errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      print(errorModel.data);
      print(e.toString());
    }
    return errorModel;
  }

  Future<ErrorModel> getDocumentsforHomePage(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: "something went wrong", data: null);
    Response res = await _client.get(Uri.parse('$host/docs/me'), headers: {
      'content-type': 'application/json; charset=UTF-8',
      tokenKey: token
    });
    switch (res.statusCode) {
      case 200:
        List<DocumentModel> list = [];
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          list.add(DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        errorModel = ErrorModel(error: null, data: list);
        break;
      default:
        errorModel = ErrorModel(error: res.body, data: null);
    }
    return errorModel;
  }

  Future<ErrorModel> updateDocumentTitle(
      {required String token,
      required String id,
      required String title}) async {
    ErrorModel errorModel = ErrorModel(error: "Some error ouccred", data: null);
    try {
      Response res = await _client.post(Uri.parse('$host/doc/title'),
          headers: {
            'content-type': 'application/json; charset=UTF-8',
            tokenKey: token
          },
          body: jsonEncode({'title': title, 'id': id}));
      switch (res.statusCode) {
        case 200:
          errorModel = ErrorModel(
              error: null, data: DocumentModel.fromJson(res.body).title);
          break;
        default:
          errorModel = ErrorModel(error: res.body, data: null);
          break;
      }
    } catch (e) {
      print("There is a error updateDocument Title\n");
      print(e.toString());
    }
    return errorModel;
  }

  Future<ErrorModel> getDocumentByid(
      {required String id, required String token}) async {
    debugPrint("came at getDocument");
    ErrorModel errorModel = ErrorModel(error: 'some error occured', data: null);
    try {
      Response res = await _client.get(Uri.parse('$host/doc/$id'), headers: {
        'content-type': 'application/json; charset=UTF-8',
        tokenKey: token
      });
      switch (res.statusCode) {
        case 200:
          errorModel =
              ErrorModel(error: null, data: DocumentModel.fromJson(res.body));
          break;
        default:
          print("This error from getDocuemnt");
          errorModel = ErrorModel(error: "Document doesn't exist", data: null);
          break;
      }
    } catch (error) {
      throw "this document doesn't exist";
    }
    return errorModel;
  }
}
