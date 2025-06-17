import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_post.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemonList({int offset = 0, int limit = 20}) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      final List<Future<Pokemon>> futures = results.map((p) => fetchPokemonDetails(p['name'])).toList();
      return await Future.wait(futures);
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<Pokemon> fetchPokemonDetails(String nameOrId, {bool fetchEvolutions = true}) async {
    final pokemonResponse = await http.get(Uri.parse('$_baseUrl/pokemon/$nameOrId'));
    if (pokemonResponse.statusCode != 200) throw Exception('Failed to load Pokémon details for $nameOrId');
    final pokemonJson = jsonDecode(pokemonResponse.body);

    final speciesUrl = pokemonJson['species']['url'];
    final speciesResponse = await http.get(Uri.parse(speciesUrl));
    if (speciesResponse.statusCode != 200) throw Exception('Failed to load Pokémon species');
    final speciesJson = jsonDecode(speciesResponse.body);

    String description = 'No description available.';
    for (var entry in speciesJson['flavor_text_entries']) {
      if (entry['language']['name'] == 'en') {
        description = entry['flavor_text'].replaceAll('\n', ' ').replaceAll('\f', ' ');
        break;
      }
    }

    List<Pokemon> evolutionChain = [];
    if (fetchEvolutions && speciesJson['evolution_chain'] != null) {
      final evolutionChainUrl = speciesJson['evolution_chain']['url'];
      final evolutionChainResponse = await http.get(Uri.parse(evolutionChainUrl));
      if (evolutionChainResponse.statusCode == 200) {
        final evolutionChainJson = jsonDecode(evolutionChainResponse.body);
        var evoData = evolutionChainJson['chain'];
        do {
          final speciesName = evoData['species']['name'];
          final evolutionPokemon = await fetchPokemonDetails(speciesName, fetchEvolutions: false);
          evolutionChain.add(evolutionPokemon);
          evoData = evoData['evolves_to'].isNotEmpty ? evoData['evolves_to'][0] : null;
        } while (evoData != null);
      }
    }

    final typesList = (pokemonJson['types'] as List)
        .map<String>((typeInfo) => typeInfo['type']['name'] as String)
        .toList();

    final officialArtwork = pokemonJson['sprites']['other']['official-artwork']['front_default'];
    final defaultSprite = pokemonJson['sprites']['front_default'];

    return Pokemon(
      id: pokemonJson['id'],
      name: pokemonJson['name'],
      imageUrl: officialArtwork ?? defaultSprite,
      types: typesList,
      weight: pokemonJson['weight'],
      height: pokemonJson['height'],
      cryUrl: pokemonJson['cries']?['latest'] ?? '',
      description: description,
      evolutionChain: evolutionChain,
    );
  }

  Future<List<Pokemon>> fetchPokemonsByType(String typeName) async {
    final response = await http.get(Uri.parse('$_baseUrl/type/$typeName'));
    if (response.statusCode != 200) throw Exception('Failed to load type $typeName');

    final data = jsonDecode(response.body);
    final List pokemonList = data['pokemon'];

    final List<Future<Pokemon>> futures = pokemonList.map((p) {
      final String pokemonName = p['pokemon']['name'];
      return fetchPokemonDetails(pokemonName, fetchEvolutions: false);
    }).toList();

    return await Future.wait(futures);
  }
}
