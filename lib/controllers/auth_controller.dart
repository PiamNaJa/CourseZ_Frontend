import 'dart:convert';
import 'package:flutter/material.dart';
import '../repository/auth_repository.dart';
import 'package:get_storage/get_storage.dart';

class AuthViewModel {
  final AuthRepository _authRepository = AuthRepository();
  final GetStorage _userStorage = GetStorage('user');

  void login(String email, String password, BuildContext context) {
    int statusCode = 0;
    _authRepository.loginUser(email, password).then((response) {
      statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = json.decode(response.body);
        _userStorage.write('token', data['token']);
        _userStorage.write('refreshToken', data['refreshToken']);
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Wrong email or password'),
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        );
      }
    });
  }
  // Future<void> register(String email, String password) async {
  //   await _authRepository.register(email, password);
  // }
}