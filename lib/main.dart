import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment2/provider/card_provider.dart';
import 'package:assignment2/provider/fsvorite_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:assignment2/screens/register/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoriteProvider = FavoriteProvider();
  await favoriteProvider.loadFavorites();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(favoriteProvider: favoriteProvider));
}

class MyApp extends StatelessWidget {
  final FavoriteProvider favoriteProvider;

  const MyApp({super.key, required this.favoriteProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider<FavoriteProvider>(
            create: (_) => favoriteProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const RegisterScreen(),
      ),
    );
  }
}
