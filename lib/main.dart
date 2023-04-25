import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:my_flutter_chat_app/auth/login.dart';
import 'package:my_flutter_chat_app/homepage.dart';

/// ! We use riverpod to watch the login state change, and rebuild screen.
/// ! For more details see the riverpod example.
final currentUserStreamProvider =
StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final currentUserProvider = StateProvider<User?>((ref) {
  return ref.watch(currentUserStreamProvider).maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});

final _kLoginProviderConfigs = [
  GoogleProviderConfiguration(
    //! The clientId is copied from the app's Firebase console.
    clientId:
    '785184947614-k4q21aq3rmasodkrj5gjs9qtqtkp89tt.apps.googleusercontent.com',
  ),
  EmailProviderConfiguration(),
];


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      themeMode: ThemeMode.light,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return SignInScreen(
        providerConfigs: _kLoginProviderConfigs,
        headerBuilder: (_, __, ___) => Padding(
          padding: const EdgeInsets.all(8.0),
          // child: kAppIcon,
        ),
        // ! Currently there's no providerConfig for Anonymous sign in, so we
        // add a btn ourselves.
        footerBuilder: (context, _) {
          return ElevatedButton.icon(
            icon: Icon(CommunityMaterialIcons.incognito),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            label: const Text('Log in anonymously'),
            onPressed: FirebaseAuth.instance.signInAnonymously,
          );
        },
      );
    } else {
      return const MyHomePage();
    }
  }
}


