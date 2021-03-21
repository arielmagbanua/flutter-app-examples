import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final List properties = const <dynamic>[];

  Failure([properties]);

  @override
  List<Object> get props => [properties];
}
