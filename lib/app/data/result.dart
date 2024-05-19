import 'package:equatable/equatable.dart';

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
  const ResultFailure(this.exception);

  final Exception exception;

  String get message => exception.toString();

  @override
  List<Object?> get props => [exception];
}
