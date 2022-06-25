import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/photos_bloc.dart';
import '../widgets/photo_grid.dart';
import '../../../../service_container.dart';

class GridPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
      ),
      body: BlocProvider(
        create: (_) => sl<PhotosBloc>()..add(PhotosFetched()),
        child: PhotoGrid(),
      ),
    );
  }
}
