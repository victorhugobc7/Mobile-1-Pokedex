import 'package:flutter/material.dart';
import '../models/pokemon_post.dart';
import '../screens/timeline_screen.dart';
import '../screens/pokemon_details_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/search_screen.dart';
import '../screens/First_screen.dart';
import '../screens/type_results_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String timeline = '/timeline';
  static const String details = '/pokemon';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String typeResults = '/type';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case timeline:
        return MaterialPageRoute(builder: (_) => const TimelineScreen());

      case details:
        if (settings.arguments is Pokemon) {
          final pokemon = settings.arguments as Pokemon;
          return MaterialPageRoute(builder: (_) => PokemonDetailScreen(pokemon: pokemon));
        }
        return _errorRoute('Rota invalida.');

      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case typeResults:
        if (settings.arguments is String) {
          final typeName = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => TypeResultsScreen(typeName: typeName));
        }
        return _errorRoute('ipo inválido.');

      default:
        return _errorRoute('Página não encontrada.');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
