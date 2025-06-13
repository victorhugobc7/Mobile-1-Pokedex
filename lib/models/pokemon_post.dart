class Pokemon {
  final String name;
  final String imageUrl;
  final String firstTypeSlot;
  final String secondTypeSlot;
  final int weight;
  final int height;
  final String cryUrl;


  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.firstTypeSlot,
    required this.secondTypeSlot,
    required this.weight,
    required this.height,
    required this.cryUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final imageUrl = json['sprites']['front_default'];
    final firstTypeSlot = json['types'][0]['type']['name'];
    final secondTypeSlot = json['types'][1]['type']['name'] | '';
    final weight = json['weight'];
    final height = json['height'];
    final cryUrl = json['cries']['latest'];

    return Pokemon(
        name: name,
        imageUrl: imageUrl,
        firstTypeSlot: firstTypeSlot,
        secondTypeSlot: secondTypeSlot,
        weight: weight,
        height: height,
        cryUrl: cryUrl,
    );
  }
}