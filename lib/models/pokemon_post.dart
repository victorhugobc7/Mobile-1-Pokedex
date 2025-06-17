class Pokemon {
  final String name;
  final String imageUrl;
  final List<String> types;
  final int weight;
  final int height;
  final String cryUrl;
  final int id;
  final String description;
  final List<Pokemon> evolutionChain;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.weight,
    required this.height,
    required this.cryUrl,
    required this.id,
    required this.description,
    required this.evolutionChain,
  });

  double get weightInKg => weight / 10.0;
  double get heightInMeters => height / 10.0;
}
