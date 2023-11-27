import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:numtrivia/domain/entities/number_trivia.dart';
import 'package:numtrivia/domain/usecases/get_concrete_number_trivia.dart';

import '../repositories/number_trivia_repository_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  setUpAll(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  test(
    'should get trivia for the number from the repository',
        () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await usecase(Params(number: tNumber));

      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}