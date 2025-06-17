import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../config/app_routes.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../components/error_view.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final _apiService = ApiService();
  final List<Pokemon> _pokemonList = [];
  final ScrollController _scrollController = ScrollController();

  final ValueNotifier<bool> _isDialOpen = ValueNotifier(false);

  int _offset = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

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
    _isDialOpen.dispose();
    super.dispose();
  }

  Future<void> _loadMorePokemon() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

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
        });
      }
    } catch (e) {
      if(mounted) setState(() => _error = "Falha ao carregar Pokémon.");
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isDialOpen.value) {
          _isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokédex')),
        body: _buildBody(),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          openCloseDial: _isDialOpen,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.favorite),
              label: 'Favoritos',
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              onTap: () {
                _isDialOpen.value = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    Navigator.pushNamed(context, AppRoutes.favorites);
                  }
                });
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.search),
              label: 'Pesquisar',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onTap: () {
                _isDialOpen.value = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (mounted) {
                    Navigator.pushNamed(context, AppRoutes.search);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_pokemonList.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _pokemonList.isEmpty) {
      return ErrorView(message: _error!, onRetry: _loadMorePokemon);
    }
    return Consumer<FavoritesService>(
      builder: (context, favoritesService, child) {
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12.0),
          itemCount: _pokemonList.length + (_hasMore || _error != null ? 1 : 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index >= _pokemonList.length) {
              if (_error != null) {
                return Center(
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red, size: 30),
                    onPressed: _loadMorePokemon,
                  ),
                );
              }
              return _hasMore ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
            }
            final pokemon = _pokemonList[index];
            return PokeCell(
              pokemon: pokemon,
              isFavorite: favoritesService.isFavorite(pokemon.id),
            );
          },
        );
      },
    );
  }
}
