part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PhotosFetched extends PhotosEvent {}

class Refresh extends PhotosEvent {}
