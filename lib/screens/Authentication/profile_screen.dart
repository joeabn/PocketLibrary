import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../services/fire_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  User? _currentUser = null;

  Future<void> getCurrentUser() async {
    var loggedInUser = (await FireAuth.getCurrentUser())!;
    setState(() {
      _currentUser = loggedInUser;
    });
    print("Looking for user");
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: kRedColor,
      ),
      body: _currentUser == null
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NAME: ${_currentUser!.displayName}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'EMAIL: ${_currentUser!.email}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 16.0),
                  _currentUser!.emailVerified
                      ? Text(
                          'Email verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.green),
                        )
                      : Text(
                          'Email not verified',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.red),
                        ),
                  const SizedBox(height: 16.0),
                  _isSendingVerification
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isSendingVerification = true;
                                });
                                await _currentUser!.sendEmailVerification();
                                setState(() {
                                  _isSendingVerification = false;
                                });
                              },
                              child: const Text('Verify email'),
                            ),
                            const SizedBox(width: 8.0),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () async {
                                User? user = await FireAuth.getCurrentUser(
                                    currentUser: _currentUser);

                                if (user != null) {
                                  setState(() {
                                    _currentUser = user;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                  const SizedBox(height: 16.0),
                  _isSigningOut
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await FirebaseAuth.instance.signOut();
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text('Sign out'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
