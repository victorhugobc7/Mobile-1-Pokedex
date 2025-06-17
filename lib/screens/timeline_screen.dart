import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../config/app_routes.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _apiService = ApiService();
  final List<Pokemon> _pokemonList = [];
  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMorePokemon();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500 && !_isLoading) {
        _loadMorePokemon();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final newPokemons = await _apiService.fetchPokemonList(offset: _offset);
      if (mounted) {
        setState(() {
          if (newPokemons.isEmpty) {
            _hasMore = false;
          } else {
            _pokemonList.addAll(newPokemons);
            _offset += 20;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Consumer<FavoritesService>(
        builder: (context, favoritesService, child) {
          if (_pokemonList.isEmpty && _isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_pokemonList.isEmpty && !_isLoading) {
            return const Center(child: Text("Nenhum Pokémon encontrado. Verifique sua conexão."));
          }
          return GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12.0),
            itemCount: _pokemonList.length + (_hasMore ? 1 : 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              if (index >= _pokemonList.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final pokemon = _pokemonList[index];
              return PokeCell(
                pokemon: pokemon,
                isFavorite: favoritesService.isFavorite(pokemon.id),
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.favorite),
            label: 'Favoritos',
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
          ),
          SpeedDialChild(
            child: const Icon(Icons.search),
            label: 'Pesquisar',
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
        ],
      ),
    );
  }
}
