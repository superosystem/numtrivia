import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/core/usecases/usecases.dart';
import 'package:numtrivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/domain/usecases/get_random_number_trivia.dart';

import '../repositories/number_trivia_repository_test.mocks.dart';

@GenerateMocks([GetRandomNumberTrivia])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUpAll(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  test(
    'should get trivia from the repository',
        () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}