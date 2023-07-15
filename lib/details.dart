import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class details extends StatefulWidget {
  const details({super.key});

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  String ans = "";
  @override
  void initState() {
    super.initState();
    askQuestion();
  }

  showwidget() {
    if (ans == "") {
      return CircularProgressIndicator(
        color: Colors.red,
      );
    } else {
      return Padding(
          padding: EdgeInsets.all(15),
          child: AnimatedTextKit(isRepeatingAnimation: false, animatedTexts: [
            TyperAnimatedText(
              textAlign: TextAlign.start,
              ans,
              textStyle: GoogleFonts.pressStart2p(
                height: 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            )
          ]));
    }
  }

  final String apiUrl = 'https://chatgpt-api7.p.rapidapi.com/ask';

  final Map<String, String> headers = {
    'content-type': 'application/json',
    'X-RapidAPI-Key': 'e47da9067fmsh5ff9ccd4c986c74p16e758jsncb64922ec1cc',
    'X-RapidAPI-Host': 'chatgpt-api7.p.rapidapi.com',
  };
  var response;
  Future askQuestion() async {
    final String jsonData =
        '{"query":"Tell me about ${HomeState.pokemonname} pokemon"}';
    response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonData,
    );
    if (response.statusCode == 200) {
      if (response.body != null) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          ans = jsonData['response'];
        });
        print(ans);
      } else {
        ans = "";
      }
    } else {
      throw Exception(
          'Failed to load data, status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                child: Image.asset('assets/pokeball.svg.png'),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Text(
                "Pokedex",
                style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ],
          )),
      body: SingleChildScrollView(
          reverse: true,
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text(
                  HomeState.pokemonname,
                  style: GoogleFonts.pressStart2p(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.06),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Image.network(
                  HomeState.imageurl,
                  scale: 0.5,
                  filterQuality: FilterQuality.high,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                showwidget()
              ],
            ),
          )),
      backgroundColor: Color.fromARGB(255, 44, 44, 44),
    );
  }
}
