import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  static const _favoritesKey = 'favorite_pokemons';
  final Set<int> _favoritePokemonIds = {};

  Set<int> get favoritePokemonIds => _favoritePokemonIds;

  FavoritesService() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = prefs.getStringList(_favoritesKey) ?? [];
    _favoritePokemonIds.addAll(favoriteIdsAsString.map(int.parse));
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIdsAsString = _favoritePokemonIds.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIdsAsString);
  }

  bool isFavorite(int pokemonId) {
    return _favoritePokemonIds.contains(pokemonId);
  }

  void toggleFavorite(int pokemonId) {
    if (isFavorite(pokemonId)) {
      _favoritePokemonIds.remove(pokemonId);
    } else {
      _favoritePokemonIds.add(pokemonId);
    }
    _saveFavorites();
    notifyListeners();
  }
}
