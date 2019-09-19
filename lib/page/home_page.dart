import 'dart:convert';

import 'package:cgv/model/movie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DiscoverWidget extends StatelessWidget {
  Future<List<Movie>> getDiscover() async {
    try {
      Response response = await Dio().get(
          "https://api.themoviedb.org/3/discover/tv?api_key=de2ed78c355f987d0230fd0b9772471e&language=en-US&sort_by=popularity.desc&page=40&timezone=America%2FNew_York&include_null_first_air_dates=false");
      return Movie.parseMovieList(response.data);
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Movie>>(
        future: getDiscover(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildMovieRow(snapshot.data[index]);
              });
        },
      ),
    );
  }

  Widget _buildMovieRow(Movie movie) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Image.network(
              'https://image.tmdb.org/t/p/w185_and_h278_bestv2/${movie.posterPath}'),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movie.originalName,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  movie.overview.isEmpty
                      ? Text('empty')
                      : Text(
                          movie.overview?.substring(0, 100),
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    DiscoverWidget(),
    Text(
      'Trending',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walt Disney'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart),
            title: Text('Discover'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
