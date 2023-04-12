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
      List<String> fetch(int i) => collections[0][i].toListOfStrings();
      expect(collections[0].numberOfTerms, 6);
      expect(fetch(0), ['a']);
      expect(fetch(1), ['b']);
      expect(fetch(2), ['c']);
      expect(fetch(3), ['d']);
      expect(fetch(4), ['e']);
      expect(fetch(5), ['f']);
    });

    test('Nested list 2', () {
      List<String> fetch(int i) => collections[1][i].toListOfStrings();
      expect(collections[1].numberOfTerms, 9);
      expect(fetch(0), ['g']);
      expect(fetch(1), ['h']);
      expect(fetch(2), ['i']);
      expect(fetch(3), ['e']);
      expect(fetch(4), ['f']);
      expect(fetch(5), ['a']);
      expect(fetch(6), ['b']);
      expect(fetch(7), ['c']);
      expect(fetch(8), ['d']);
    });

    test('Cartesian list', () {
      List<String> fetch(int i) => collections[2][i].toListOfStrings();
      expect(collections[2].numberOfTerms, 8);
      expect(fetch(0), ['e', 'a']);
      expect(fetch(1), ['e', 'b']);
      expect(fetch(2), ['e', 'c']);
      expect(fetch(3), ['e', 'd']);
      expect(fetch(4), ['f', 'a']);
      expect(fetch(5), ['f', 'b']);
      expect(fetch(6), ['f', 'c']);
      expect(fetch(7), ['f', 'd']);
    });
  });
}
