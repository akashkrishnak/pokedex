import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokedex/details.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => HomeState();
}

class Pokemon {
  final String name;
  final String image;
  final String type;
  final int id;

  Pokemon({
    required this.name,
    required this.image,
    required this.type,
    required this.id,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      image: json['sprites']['front_default'],
      type: json['types'].map((type) => type['type']['name']).join(', '),
      id: json['id'],
    );
  }
}

class HomeState extends State<Home> {
  List<Pokemon> pokemonList = [];
  static String pokemonname = "";
  static String imageurl = "";
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    fetchPokemon();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
    } else {
      setState(() {
        hasInternet = true;
      });
    }
    print(hasInternet);
  }

  Future<void> fetchPokemon() async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=700');
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    final pokemonUrls = data['results'] as List<dynamic>;
    final promises = pokemonUrls.map((pokemonUrl) {
      final url = Uri.parse(pokemonUrl['url']);
      return http.get(url).then((res) => res.body);
    });

    final results = await Future.wait(promises);
    final pokemon = results.map((result) {
      final json = jsonDecode(result);
      return Pokemon.fromJson(json);
    }).toList();

    setState(() {
      pokemonList = pokemon;
    });
  }

  Widget build(BuildContext context) {
    Widget screen() {
      if (hasInternet == false) {
        return Center(
            child: Text(
          "No Internet",
          style: GoogleFonts.pressStart2p(
              color: Colors.white, fontWeight: FontWeight.bold),
        ));
      } else {
        if (pokemonList.length == 0) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 164, 44, 35),
            ),
          );
        } else {
          return GridView.builder(
            itemCount: pokemonList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              final pokemon = pokemonList[index];
              return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(6.0),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 124, 16, 16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Image.network(pokemon.image),
                        Text(
                          pokemon.name,
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  pokemonname = pokemonList[index].name;
                  imageurl = pokemonList[index].image;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => details()),
                  );
                },
              );
            },
          );
        }
      }
    }

    TextEditingController read = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Image.asset('assets/pokeball.svg.png'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pokedex",
                    style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  // GestureDetector(
                  //   child: Icon(Icons.search),
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         String inputText = '';
                  //         return AlertDialog(
                  //           backgroundColor: Color.fromARGB(255, 41, 41, 41),
                  //           title: Text(
                  //             "Search Pokemon",
                  //             style: GoogleFonts.pressStart2p(
                  //                 color: Colors.white,
                  //                 fontWeight: FontWeight.bold,
                  //                 fontSize:
                  //                     MediaQuery.of(context).size.width * 0.04),
                  //           ),
                  //           content: TextField(
                  //             controller: read,
                  //             cursorColor: Colors.red,
                  //             style: TextStyle(color: Colors.red),
                  //             decoration: InputDecoration(
                  //               filled: true,
                  //               hintText: 'Pokemon name',
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(
                  //                   color: Colors.red,
                  //                   width: 2.0,
                  //                 ),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(20.0),
                  //                 borderSide: BorderSide(
                  //                   color: Colors.red,
                  //                   width: 2.0,
                  //                 ),
                  //               ),
                  //               contentPadding: EdgeInsets.all(10.0),
                  //             ),
                  //           ),
                  //           actions: [
                  //             Center(
                  //               child: ElevatedButton(
                  //                 child: Text('Submit'),
                  //                 style: ElevatedButton.styleFrom(
                  //                     shape: RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(10.0),
                  //                     ),
                  //                     backgroundColor: Colors.red),
                  //                 onPressed: () {
                  //                   pokemonname = read.text;
                  //                   Navigator.of(context)
                  //                       .pop(); // Close the dialog
                  //                   Navigator.push(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => details()),
                  //                   );
                  //                 },
                  //               ),
                  //             )
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  // )
                ],
              ),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: screen(),
      backgroundColor: Color.fromARGB(255, 44, 44, 44),
    );
  }
}
