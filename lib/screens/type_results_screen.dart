import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../components/error_view.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class TypeResultsScreen extends StatefulWidget {
  final String typeName;
  const TypeResultsScreen({super.key, required this.typeName});

  @override
  State<TypeResultsScreen> createState() => _TypeResultsScreenState();
}

class _TypeResultsScreenState extends State<TypeResultsScreen> {
  late Future<List<Pokemon>> _pokemonsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _pokemonsFuture = _apiService.fetchPokemonsByType(widget.typeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipo: ${widget.typeName[0].toUpperCase() + widget.typeName.substring(1)}'),
      ),
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              message: 'Erro ao carregar Pokémon do tipo ${widget.typeName}.',
              onRetry: _fetchData,
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum Pokémon encontrado para este tipo.'));
          }

          final pokemons = snapshot.data!;
          return Consumer<FavoritesService>(
            builder: (context, favoritesService, child) {
              return GridView.builder(
                padding: const EdgeInsets.all(12.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = pokemons[index];
                  return PokeCell(
                    pokemon: pokemon,
                    isFavorite: favoritesService.isFavorite(pokemon.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
