/// UseCase
///
/// The base UseCase class with generics.
/// [R] - The return type which will be wrapped with future.
/// [A] - The type of arguments.
abstract class UseCase<R, A> {
  Future<R> call(A? args);
}
