import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../core/errors/failures.dart';
import '../../core/usecases/usecases.dart';
import '../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaEmpty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      emit(NumberTriviaEmpty());
      Either<Failure, int> inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      inputEither.fold((failure) {
        emit(NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        emit(NumberTriviaLoading());
        Either<Failure, NumberTrivia> failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        _eitherLoadedOrErrorState(failureOrTrivia);
      });
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      Either<Failure, NumberTrivia> failureOrTrivia =
          await getRandomNumberTrivia(NoParams());
      if (kDebugMode) {
        print(failureOrTrivia);
      }
      _eitherLoadedOrErrorState(failureOrTrivia);
    });
  }

  _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async {
    failureOrTrivia.fold(
      (failure) =>
          emit(NumberTriviaError(message: _mapFailureToMessage(failure))),
      (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailures:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailures:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
