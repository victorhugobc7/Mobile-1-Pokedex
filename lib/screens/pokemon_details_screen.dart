import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon_post.dart';
import '../services/favorites_service.dart';
import '../config/app_routes.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    const typeColors = {
      'grass': Colors.green, 'fire': Colors.red, 'water': Colors.blue,
      'poison': Colors.purple, 'electric': Colors.orange, 'rock': Colors.brown,
      'ground': Colors.brown, 'bug': Colors.lightGreen, 'psychic': Colors.pink,
      'fighting': Colors.deepOrange, 'ghost': Colors.indigo, 'flying': Colors.lightBlue,
      'normal': Colors.grey, 'fairy': Colors.pinkAccent, 'dark': Colors.brown,
      'steel': Colors.blueGrey, 'ice': Colors.cyanAccent, 'dragon': Colors.deepPurple,
    };

    final primaryColor = typeColors[pokemon.types.first] ?? Colors.grey;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenSize.height * 0.4,
            pinned: true,
            backgroundColor: primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Consumer<FavoritesService>(
                builder: (context, favoritesService, child) {
                  final isFavorite = favoritesService.isFavorite(pokemon.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Remover Favorito'),
                            content: Text('Tem certeza que deseja remover ${pokemon.name[0].toUpperCase() + pokemon.name.substring(1)} dos favoritos?'),
                            actions: [
                              TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(ctx).pop()),
                              TextButton(
                                child: const Text('Remover'),
                                onPressed: () {
                                  favoritesService.toggleFavorite(pokemon.id);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        favoritesService.toggleFavorite(pokemon.id);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(content: Text('${pokemon.name[0].toUpperCase() + pokemon.name.substring(1)} adicionado aos favoritos!')),
                          );
                      }
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.cover,
                    color: primaryColor.withOpacity(0.5),
                    colorBlendMode: BlendMode.dstATop,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(color: Colors.black.withOpacity(0.1)),
                  ),
                  Center(
                    child: Hero(
                      tag: 'pokemon-${pokemon.id}',
                      child: Image.network(
                        pokemon.imageUrl,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: pokemon.types
                            .map((type) => InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.typeResults, arguments: type);
                          },
                          child: _TypeChip(type: type, color: primaryColor),
                        ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: 'Descrição'),
                    Text(
                      pokemon.description,
                      style: const TextStyle(color: Colors.black54, fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoPill(label: 'Peso', value: '${pokemon.weightInKg.toStringAsFixed(1)} kg'),
                        _InfoPill(label: 'Altura', value: '${pokemon.heightInMeters.toStringAsFixed(1)} m'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (pokemon.evolutionChain.length > 1) ...[
                      const _SectionTitle(title: 'Linha de Evolução'),
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: pokemon.evolutionChain.length,
                          separatorBuilder: (context, index) => const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                          itemBuilder: (context, index) {
                            final evo = pokemon.evolutionChain[index];
                            return InkWell(
                              onTap: () {
                                if (pokemon.id != evo.id) {
                                  Navigator.pushNamed(context, AppRoutes.details, arguments: evo);
                                }
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(radius: 40, backgroundImage: NetworkImage(evo.imageUrl)),
                                  const SizedBox(height: 8),
                                  Text(evo.name[0].toUpperCase() + evo.name.substring(1)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  final Color color;
  const _TypeChip({required this.type, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type[0].toUpperCase() + type.substring(1),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;
  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
