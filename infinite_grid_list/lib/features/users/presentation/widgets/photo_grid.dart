import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_loader.dart';
import 'photo_card.dart';
import '../bloc/photos_bloc.dart';

class PhotoGrid extends StatefulWidget {
  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  final _scrollController = ScrollController();
  late PhotosBloc _photosBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _photosBloc = context.read<PhotosBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotosBloc, PhotosState>(
      builder: (BuildContext context, state) {
        switch(state.status) {
          case PhotosStatus.failure:
            return const Center(child: Text('Failed to fetch photos!'));

          case PhotosStatus.success:
            return GridView.builder(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return index >= state.photos.length ? BottomLoader() : PhotoCard(state.photos[index]);
              },
              itemCount: state.hasReachedMax ? state.photos.length : state.photos.length + 1,
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
            );

          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _photosBloc.add(PhotosFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) {
      return false;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
