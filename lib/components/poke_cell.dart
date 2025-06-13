import 'package:flutter/material.dart';

class pokeCell extends StatelessWidget {

  pokeCell({super.key});
  bool isFavorite = false;
  String pokemonName = 'Bulbasaur';
  String pokemonUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png';

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.all(5),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [ BoxShadow(
          color: Colors.grey.withValues(alpha: 0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )],
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child:
          Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(pokemonName,
                      style: TextStyle(color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                      )
                  ),
                ),
              ),
              Opacity(
                opacity: isFavorite ? 1.0 : 0.0,
                child: Icon(Icons.star, color: Colors.yellow,),
              ),
              Image(
                    image: NetworkImage(pokemonUrl)
              ),
            ],
          ),
      ),
    );
}
}