import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';




class PeliculasSearch extends SearchDelegate {

  final peliculasProvider = new PeliculasProvider();


  @override
  List<Widget> buildActions(BuildContext context) {
    // Las Acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = ''; 
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
      
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los Resultados que vamos a Mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Las Sugerencias que Aparecen cunado la persona escribe

    if(query.isEmpty)
    {
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId='';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else{
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
          );
        }
      },
    );
  }

}