import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/poke_cell.dart';
import '../components/error_view.dart';
import '../models/pokemon_post.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();

  Pokemon? _foundPokemon;
  bool _isLoading = false;
  String? _error;

  Future<void> _performSearch() async {
    final searchTerm = _searchController.text.trim().toLowerCase();
    if (searchTerm.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _error = null;
      _foundPokemon = null;
    });

    try {
      final pokemon = await _apiService.fetchPokemonDetails(searchTerm);
      if (mounted) setState(() => _foundPokemon = pokemon);
    } catch (e) {
      if (mounted) setState(() => _error = 'Falha ao buscar Pokémon.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Digite o nome do Pokémon',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildResultView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return ErrorView(message: _error!, onRetry: _performSearch);
    }
    if (_foundPokemon != null) {
      return Consumer<FavoritesService>(
        builder: (context, favoritesService, child) {
          return Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: PokeCell(
                pokemon: _foundPokemon!,
                isFavorite: favoritesService.isFavorite(_foundPokemon!.id),
              ),
            ),
          );
        },
      );
    }
    return const Center(child: Text('Digite para iniciar uma busca.'));
  }
}
