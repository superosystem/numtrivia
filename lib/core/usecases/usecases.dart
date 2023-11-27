// This Dart code defines a generic UseCase abstraction for application use cases.
// It utilizes the dartz library for functional programming constructs.

// UseCase abstract class outlines the structure of use cases in the application.
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  // The call method represents the execution of the use case.
  Future<Either<Failure, Type>> call(Params params);
}

// NoParams class represents a case where a use case doesn't require any specific parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
