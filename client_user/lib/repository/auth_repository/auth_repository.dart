import 'dart:async';

import 'package:client_user/controller/home_controller.dart';
import 'package:client_user/modal/users.dart';
import 'package:client_user/repository/exceptions/signup_email_password_failure.dart';
import 'package:client_user/screens/continue_confim_info/screen_continue_info.dart';
import 'package:client_user/screens/fobiden/screen_fobident.dart';
import 'package:client_user/screens/forget_password/forget_password_otp/screen_otp%20phone.dart';
import 'package:client_user/screens/home/screen_home.dart';
import 'package:client_user/screens/login/screen_login.dart';
import 'package:client_user/screens/welcome/screen_welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Variables
  RxList<UserSnapshot> usersnapshot = RxList<UserSnapshot>();
  final user = Users().obs;
  final users = UserSnapshot(user: Users(), documentReference: null).obs;
  final box = GetStorage();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final userAdmin = UserSnapshot(user: Users(), documentReference: null).obs;
  StreamSubscription? userAdminSubscription;
  var verificationId = "".obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    Future.delayed(const Duration(seconds: 6));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    if (_auth.currentUser != null) {
      bindingUser(_auth.currentUser!.uid);
    }
    bindingAdminUser();
  }

  void bindingUser(id) {
    users.bindStream(UserSnapshot.getUser(id));

    users.listen((snapshotList) async {
      final currentToken = await FirebaseMessaging.instance.getToken();
      if (currentToken != users.value.user!.Token) {
        if (snapshotList.user != null) {
          final UserSnapshot snapshot = snapshotList;
          final Users user = snapshot.user!;

          updateTokenIfNeededS(user);
        }
      }
    });
  }

  bindingAdminUser() {
    userAdmin.bindStream(UserSnapshot.getUserAdminStream());
  }

  void updateTokenIfNeeded(Users user) async {
    String? currentToken = await FirebaseMessaging.instance.getToken();
    if (currentToken != user.Token) {
      user.Token = currentToken;

      UserSnapshot(user: user, documentReference: null).capNhat(user);
    }
  }

  Future<void> updateUserData(String userId, Users newUser) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final snapshot = UserSnapshot(
          user: newUser,
          documentReference: userDoc.reference,
        );

        await snapshot.capNhat(newUser);

        Get.snackbar(
          'Success',
          'User data updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          'Error',
          'User document not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (email != "" && password != "") {
        // Check Login
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // ignore: unnecessary_null_comparison
        if (userCredential != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            final userData = userDoc.data();
            if (userData != null) {
              if (userData['Status'] == false) {
                Get.to(() => const ScreenFobident());
              }
              if (userData['Status'] == true) {
                Get.to(() => const ScreenHome());
              }
            }
          }

          Get.snackbar('Suceess', "Login To Success",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.greenAccent.withOpacity(0.1),
              colorText: Colors.black);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
        }
      } else {
        Get.snackbar('Error', "Data Invalid",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // ignore: avoid_print, prefer_interpolation_to_compose_strings
      print("ID: " + currentUser.uid);
    }
  }

  void updateUser(Users newUser) {
    user.update((val) {
      val!.Id = newUser.Id;
      val.Address = newUser.Address;
      val.Avatar = newUser.Avatar;
      val.Name = newUser.Name;
      val.Email = newUser.Email;
      val.PackageType = newUser.PackageType;
      val.Phone = newUser.Phone;
      val.Password = newUser.Password;
      val.Status = newUser.Status;
      val.ActiveAt = newUser.ActiveAt;
      val.CreatedAt = newUser.CreatedAt;
    });
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String username, String phone) async {
    try {
      // Check User Credential
      final userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(
            () => Get.snackbar('Success', "Create Account Success",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.greenAccent.withOpacity(0.1),
                colorText: Colors.black),
          );
      // Check and Save UID
      if (userCredential.user!.uid != "") {
        box.write('idCredential', userCredential.user!.uid);
      }

      if (userCredential.user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("UserId", userCredential.user!.uid);
      }

      // Add Data to Db Collection
      final timestampObject = Timestamp.now();
      final timestampNumber = timestampObject.toDate().millisecondsSinceEpoch;

      await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({
            "Id": userCredential.user!.uid,
            'Name': username,
            'Email': email,
            "Password": password,
            'Phone': phone,
            'Address': "",
            'Avatar': "",
            'PackageType': "",
            'Status': false,
            'ActiveAt': 0,
            'CreatedAt': timestampNumber,
            'isAdmin': false
          })
          .whenComplete(
            () => Get.snackbar('Success', "Create Profile Success",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.greenAccent.withOpacity(0.1),
                colorText: Colors.black),
          )
          .catchError((e) => {
                Get.snackbar('Error', "Create Profile Fail",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
                    colorText: Colors.black)
              });
      // Check when complete change screen to continue update data
      // ignore: unnecessary_null_comparison
      if (userCredential != null) {
        Get.offAll(() => const ScreenContinueInfo());
      } else {
        Get.offAll(() => const ScreenWelcome());
      }
      // Check Error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Password is not strong enough', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Email already used for another account', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      } else {
        Get.snackbar('Registration failed', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      }
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      Get.snackbar('Error', ex.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);
      throw ex;
    }
  }

  Future<void> confirmInfo(
      String userId, List<Map<String, dynamic>> updates) async {
    try {
      final userRef = _firestore.collection('Users').doc(userId);
      // ignore: prefer_collection_literals
      final dataToUpdate = Map<String, dynamic>();
      for (final update in updates) {
        dataToUpdate.addAll(update);
      }
      // ignore: void_checks
      await userRef.update(dataToUpdate).whenComplete(() {
        Get.to(() => const ScreenHome());
        Get.snackbar('Update', "Update Proifile Success",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent.withOpacity(0.1),
            colorText: Colors.black);
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.1),
          colorText: Colors.black);
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? usersk = userCredential.user;

      if (usersk != null) {
        final DocumentSnapshot userSnapshot =
            await _firestore.collection('Users').doc(usersk.uid).get();

        if (userSnapshot.exists) {
          // Người dùng đã tồn tại trong Firestore
          // Cập nhật thông tin người dùng=
          if (userSnapshot['Status'] == false) {
            // Người dùng chưa được chấp nhận, chuyển đến trang "walting"
            Get.off(() => const ScreenFobident());
          } else {
            // Người dùng đã được chấp nhận, chuyển đến trang chính
            Get.off(() => const ScreenHome());
          }
        } else {
          // Người dùng không tồn tại trong Firestore
          // Thêm thông tin người dùng vào Firestore
          final newUser = Users(
              Id: usersk.uid,
              Name: usersk.displayName,
              Email: usersk.email,
              Avatar: usersk.photoURL,
              Status: false,
              CreatedAt: DateTime.now().millisecondsSinceEpoch,
              PackageType: "",
              Password: "GG",
              Address: "",
              ActiveAt: 0,
              Phone: "32522353",
              isAdmin: false);

          await _firestore
              .collection('Users')
              .doc(usersk.uid)
              .set(newUser.toJson());

          // Cập nhật thông tin người dùng
          user.update((val) {
            val!.Id = newUser.Id;
            val.Name = newUser.Name;
            val.Email = newUser.Email;
            val.Avatar = newUser.Avatar;
            val.Status = newUser.Status;
            val.CreatedAt = newUser.CreatedAt;
            val.PackageType = newUser.PackageType;
            val.Password = newUser.Password;
            val.Address = newUser.Address;
            val.ActiveAt = newUser.ActiveAt;
            val.Phone = newUser.Phone;
          });

          // Chuyển đến trang "walting"
          Get.off(() => const ScreenFobident());
        }
      } else {
        // Đăng nhập thất bại hoặc không có người dùng
        Get.snackbar(
          'Error',
          "Login Account GG Fail",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      // Xử lý lỗi
      Get.snackbar(
        'Error',
        "Login Account GG Fail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut(); // Đăng xuất khỏi Google
      await _auth.signOut(); // Đăng xuất khỏi Firebase
      // Đặt các giá trị khởi tạo hoặc xóa thông tin người dùng
      user.update((val) {
        val!.Id = "";
        val.Name = "";
        val.Email = "";
        val.Avatar = "";
        val.Status = false;
        val.CreatedAt = 0;
        val.PackageType = "";
        val.Password = "";
        val.Address = "";
        val.ActiveAt = 0;
        val.Phone = "";
      });
      Get.offAll(() => const ScreenLogin()); // Chuyển hướng đến trang đăng nhập
      Get.snackbar(
        'Success',
        "Logout Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
    } catch (e) {
      // Xử lý lỗi
      Get.snackbar(
        'Error',
        "Logout Failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.black,
      );
    }
  }

  checkData(id) async {
    if (id != "") {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();
      if (!doc.exists) {
        box.write('data', "NoData");
        Get.snackbar('Error', "No Data To User Query",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      } else {
        // ignore: avoid_print
        print(doc.get("Name"));
        box.write('data', "List Data");
        Users newUser = Users()
          ..Id = doc.get('Id')
          ..Address = doc.get('Address')
          ..Avatar = doc.get('Avatar')
          ..Name = doc.get('Name')
          ..Email = doc.get('Email')
          ..PackageType = doc.get('PackageType')
          ..Phone = doc.get('Phone')
          ..Password = doc.get('Password')
          ..Status = doc.get('Status')
          ..ActiveAt = doc.get('ActiveAt')
          ..CreatedAt = doc.get('CreatedAt');

        updateUser(newUser);
      }
    }
  }

  void phoneAuthentication(phoneNo) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          if (e.code == "invalid-phone-number") {
            Get.snackbar("Error", "The provided phone number is not valid.");
          } else {
            Get.snackbar("Error", "Something went wrong. Try again");
          }
        },
        codeSent: (verificationId, forceResendingToken) async {
          this.verificationId.value = verificationId;
          String smsCode = '';
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: smsCode);
          Get.to(() => ScreenOTPPhone(
                verificationId: verificationId,
                phone: phoneNo,
              ));
          await _auth.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials =
        await _auth.signInWithCredential(PhoneAuthProvider.credential(
            // ignore: unnecessary_this
            verificationId: this.verificationId.value,
            smsCode: otp));

    return credentials.user != null ? true : false;
  }

  Future<String?> createUserWithEmailAndPasswordv2(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = _auth.currentUser;
      if (user != null) {
        final userRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await userRef.set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          // add more user information here
        });
        return null; // return null when succeed
      } else {
        throw Exception('Cannot create user'); // or throw an exception
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      // ignore: avoid_print
      print("FIREBASE AUTH EXCT - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SignUpWithEmailAndPasswordFailure();
      // ignore: avoid_print
      print("FIREBASE AUTH EXCT - ${ex.message}");
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.code);
    } catch (_) {}
  }

  Future<void> updateUserDatass(String id, Users userin) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;

    // Cập nhật mật khẩu của người dùng
    User? user = auth.currentUser;
    if (this.user.value.Password != userin.Password) {
      user!.updatePassword(userin.Password!).then((_) {
        Get.snackbar('Success', "Update Password Success",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent.withOpacity(0.1),
            colorText: Colors.black);
      }).catchError((error) {
        Get.snackbar('Error', error.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      });
    }

    if (this.user.value.Email != userin.Email) {
      user!.updateEmail(userin.Email!).then((_) {
        Get.snackbar('Success', "Update Email Success",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.greenAccent.withOpacity(0.1),
            colorText: Colors.black);
      }).catchError((error) {
        Get.snackbar('Error', error.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            colorText: Colors.black);
      });
    }
    // Update Data
    await usersRef
        .doc(id)
        .update(userin.toJson())
        .then((_) => {
              Get.snackbar('Success', "Update Profile Success",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.greenAccent.withOpacity(0.1),
                  colorText: Colors.black)
            })
        // ignore: body_might_complete_normally_catch_error
        .catchError((err) {
      Get.snackbar('Error', err.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.black);

      if (this.user.value.Email != userin.Email ||
          this.user.value.Password != userin.Password) {
        auth.signOut();
        Get.offAll(() => const ScreenLogin());
      }
    });
  }

  //!NOTE FCM
  void updateTokenIfNeededS(Users user) async {
    String? currentToken = await FirebaseMessaging.instance.getToken();
    if (currentToken != user.Token) {
      user.Token = currentToken;

      updateUserInfo(user.Id!, user);
    }
  }

  void updateUserInfo(String userId, Users updatedUser) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Id', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      UserSnapshot userSnapshot = UserSnapshot.fromSnapshot(documentSnapshot);
      userSnapshot.user = updatedUser;

      await userSnapshot.capNhat(updatedUser);
    }
  }
}
