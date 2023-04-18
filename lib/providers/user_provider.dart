import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';


class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
      : super(UserModel(email: '', name: '', token: '', uid: '', profilePic: '',));
      // : super(null);

UserModel get user => state;

  void setUser(UserModel userModel) {
    state = userModel;
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, UserModel>(((ref) => UserNotifier()));