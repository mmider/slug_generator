import 'package:slug_generator/src/data_containers.dart';
import 'package:test/test.dart';

void main() {
  group('Testing data containers', () {
    // final awesome = Awesome();
    final data = {
      'abcd': RawListOfWords.fromListOfStrings(
        data: ['a', 'b', 'c', 'd'],
      ),
      'ef': RawListOfWords.fromListOfStrings(
        data: ['e', 'f'],
      ),
      'ghi': RawListOfWords.fromListOfStrings(
        data: ['g', 'h', 'i'],
      ),
    };
    final collections = [
      NestedList([data['ef']!, data['abcd']!]),
      NestedList([
        data['abcd']!,
        NestedList([data['ef']!, data['ghi']!]),
      ]),
      CartesianList([data['ef']!, data['abcd']!]),
    ];

    setUp(() {
      // Additional setup goes here.
    });

    test('Nested list 1', () {
      List<String> _get(int i) => collections[0][i].toListOfStrings();
      expect(collections[0].numberOfTerms, 6);
      expect(_get(0), ['a']);
      expect(_get(1), ['b']);
      expect(_get(2), ['c']);
      expect(_get(3), ['d']);
      expect(_get(4), ['e']);
      expect(_get(5), ['f']);
    });

    test('Nested list 2', () {
      List<String> _get(int i) => collections[1][i].toListOfStrings();
      expect(collections[1].numberOfTerms, 9);
      expect(_get(0), ['g']);
      expect(_get(1), ['h']);
      expect(_get(2), ['i']);
      expect(_get(3), ['e']);
      expect(_get(4), ['f']);
      expect(_get(5), ['a']);
      expect(_get(6), ['b']);
      expect(_get(7), ['c']);
      expect(_get(8), ['d']);
    });

    test('Cartesian list', () {
      List<String> _get(int i) => collections[2][i].toListOfStrings();
      expect(collections[2].numberOfTerms, 8);
      expect(_get(0), ['e', 'a']);
      expect(_get(1), ['e', 'b']);
      expect(_get(2), ['e', 'c']);
      expect(_get(3), ['e', 'd']);
      expect(_get(4), ['f', 'a']);
      expect(_get(5), ['f', 'b']);
      expect(_get(6), ['f', 'c']);
      expect(_get(7), ['f', 'd']);
    });
  });
}
