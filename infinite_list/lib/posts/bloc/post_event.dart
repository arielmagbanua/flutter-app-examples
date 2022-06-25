part of 'post_bloc.dart';

@immutable
abstract class PostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that signifies to fetch additional posts.
class PostFetched extends PostEvent {}

/// Event that signifies to refresh the post list.
class ListRefresh extends PostEvent {}
