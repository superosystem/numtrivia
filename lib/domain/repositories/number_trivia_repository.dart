// This Dart code defines an abstract NumberTriviaRepository class,
// outlining the contract for interacting with a repository that provides number trivia data.
// It uses the dartz library for handling failures with the Either type.

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

// NumberTriviaRepository abstract class defines the interface for fetching number trivia.
abstract class NumberTriviaRepository {
  // Fetches number trivia for a specific number.
  // Returns Either a Failure or the retrieved NumberTrivia.
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  // Fetches random number trivia.
  // Returns Either a Failure or the retrieved NumberTrivia.
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
