import 'package:equatable/equatable.dart';

part 'exceptions.dart';
part 'failure.dart';

sealed class Result<T> extends Equatable {
  const Result();
}

class ResultSuccess<T> extends Result<T> {
  const ResultSuccess(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
