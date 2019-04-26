import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends Model {

  bool isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    
    // criar o usuario
    _auth.createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass
    ).then((user) async {
      
      firebaseUser = user; //salva o usuario para acessar no app
      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((e){//se deu erro

      onFail();
      isLoading = false;
      notifyListeners();

    });
  }


  void signIn() async {

    isLoading = true;
    notifyListeners();

    await Future .delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();

  }


  void recoverPass() {

  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

}