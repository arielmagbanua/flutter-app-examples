import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/entities/photo.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;

  PhotoCard(this.photo);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: <Widget>[
          Image.network(photo.url, fit: BoxFit.cover),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: SizedBox(height: 8),
                flex: 5,
              ),
              Flexible(
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      photo.title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                flex: 2,
              ),
              Flexible(
                child: ColoredBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.solidHeart),
                        onPressed: () {
                          print('heart');
                        },
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.thumbsUp),
                        onPressed: () {
                          print('like');
                        },
                      ),
                      Spacer(flex: 30),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.shareAlt),
                        onPressed: () {
                          print('share');
                        },
                      )
                    ],
                  ),
                  color: Colors.white,
                ),
                flex: 2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
