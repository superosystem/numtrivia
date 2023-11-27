import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/errors/failures.dart';
import 'package:numtrivia/core/usecases/usecases.dart';
import 'package:numtrivia/core/utils/input_converter.dart';
import 'package:numtrivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numtrivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numtrivia/presentation/bloc/number_trivia_bloc.dart';

import '../../core/utils/input_converter_test.mocks.dart';
import '../../domain/usecases/get_concrete_number_trivia_test.mocks.dart';
import '../../domain/usecases/get_random_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
@GenerateNiceMocks([MockSpec<GetRandomNumberTrivia>()])
@GenerateNiceMocks([MockSpec<InputConverter>()])
void main() {
  late final NumberTriviaBloc bloc;
  late final MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late final MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late final MockInputConverter mockInputConverter;

  // setUp(() {
  //   mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  //   mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  //   mockInputConverter = MockInputConverter();
  //
  //   bloc = NumberTriviaBloc(
  //     getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
  //     getRandomNumberTrivia: mockGetRandomNumberTrivia,
  //     inputConverter: mockInputConverter,
  //   );
  // });

  mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  mockInputConverter = MockInputConverter();

  bloc = NumberTriviaBloc(
    getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    getRandomNumberTrivia: mockGetRandomNumberTrivia,
    inputConverter: mockInputConverter,
  );

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(NumberTriviaEmpty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenAnswer((integer) => Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async* {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenAnswer((failure) => Left(InvalidInputFailure()));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((trivia) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((failure) async => Left(ServerFailures()));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((failure) async => Left(CacheFailures()));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailures()));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async* {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailures()));
        // assert later
        final expected = [
          NumberTriviaEmpty(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
