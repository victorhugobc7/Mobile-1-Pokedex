import 'package:flutter/material.dart';
import '../config/app_routes.dart';
import '../models/pokemon_post.dart';

class PokeCell extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;

  const PokeCell({
    super.key,
    required this.pokemon,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 4.0,
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.details, arguments: pokemon);
        },
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: isFavorite
                  ? const Icon(Icons.star, color: Colors.amber, size: 24)
                  : const SizedBox.shrink(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'pokemon-${pokemon.id}',
                    child: Image.network(
                      pokemon.imageUrl,
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
