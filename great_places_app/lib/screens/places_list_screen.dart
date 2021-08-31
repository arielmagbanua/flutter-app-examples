import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../providers/great_places.dart';
import './place_detail_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Consumer<GreatPlaces>(
            child: Center(
              child: Text('Got no places yet, start adding some!'),
            ),
            builder: (ctx, greatPlaces, ch) {
              if (greatPlaces.items.length <= 0) {
                return ch!;
              }

              return ListView.builder(
                itemCount: greatPlaces.items.length,
                itemBuilder: (ctx, i) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(
                      greatPlaces.items[i].image,
                    ),
                  ),
                  title: Text(greatPlaces.items[i].title),
                  subtitle: Text(greatPlaces.items[i].location.address as String),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      PlaceDetailScreen.routeName,
                      arguments: greatPlaces.items[i].id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
