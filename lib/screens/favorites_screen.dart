import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<Pokemon>>? _favoritePokemonsFuture;
  final _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorites();
  }

  void _loadFavorites() {
    // Escuta as mudanças para reconstruir quando um favorito for removido nesta tela
    final favoritesService = Provider.of<FavoritesService>(context);
    final favoriteIds = favoritesService.favoritePokemonIds;

    // Evita refazer a busca desnecessariamente se os IDs não mudaram
    // (Esta é uma otimização simples)
    if (_favoritePokemonsFuture != null && favoriteIds.isEmpty) {
      setState(() {
        _favoritePokemonsFuture = Future.value([]);
      });
      return;
    }

    final futures = favoriteIds.map((id) => _apiService.fetchPokemonDetails(id.toString(), fetchEvolutions: false));
    setState(() {
      _favoritePokemonsFuture = Future.wait(futures);
    });
  }

  @override
  Widget build(BuildContext context) {
    // O Consumer garante que a tela se reconstrua se a lista de favoritos mudar
    // e o `_loadFavorites` será chamado novamente via `didChangeDependencies`.
    return Consumer<FavoritesService>(
      builder: (context, favoritesService, child) {
        if (favoritesService.favoritePokemonIds.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Favoritos')),
            body: const Center(
              child: Text(
                'Você ainda não possui um pokémon favorito :(',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Favoritos')),
          body: FutureBuilder<List<Pokemon>>(
            future: _favoritePokemonsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar favoritos: ${snapshot.error}'));
              }
              final favoritePokemons = snapshot.data ?? [];
              if (favoritePokemons.isEmpty && favoritesService.favoritePokemonIds.isNotEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

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
          ),
        );
      },
    );
  }
}
