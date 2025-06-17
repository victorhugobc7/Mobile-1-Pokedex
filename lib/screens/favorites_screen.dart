import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../components/error_view.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Pokemon>> _favoritePokemonsFuture;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFavorites();
    });
    Provider.of<FavoritesService>(context, listen: false).addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    Provider.of<FavoritesService>(context, listen: false).removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      _fetchFavorites();
    }
  }

  void _fetchFavorites() {
    final favoriteIds = Provider.of<FavoritesService>(context, listen: false).favoritePokemonIds;
    setState(() {
      _favoritePokemonsFuture = Future.wait(
          favoriteIds.map((id) =>
              _apiService.fetchPokemonDetails(id.toString(), fetchEvolutions: false)
          ).toList()
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Consumer<FavoritesService>(
        builder: (context, favoritesService, child) {
          if (favoritesService.favoritePokemonIds.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não possui um pokémon favorito :(',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return FutureBuilder<List<Pokemon>>(
            future: _favoritePokemonsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: 'Erro ao carregar favoritos.',
                  onRetry: _fetchFavorites,
                );
              }

              final favoritePokemons = snapshot.data ?? [];

              return GridView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: favoritePokemons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final pokemon = favoritePokemons[index];
                  return PokeCell(pokemon: pokemon, isFavorite: true);
                },
              );
            },
          );
        },
      ),
    );
  }
}
