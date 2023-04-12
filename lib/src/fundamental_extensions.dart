// =============================================================================
//
//  A bunch of basic extensions of some `dart`-fundamental types that should be
//  considered as utility functions specifically for this package, with little
//  to no use outside of internals of this package.
//
// =============================================================================

import 'dart:math' show min, Random;

extension PrefixExt on String {
  /// Get the prefix of a word, with prefix defined as the first `i` number of
  /// characters (or an entire word if `i > word.length`)
  String prefix(int i) => substring(0, min(i, length));
}

extension CountingExt on Iterable<String> {
  bool get hasNoRepeats => length == toSet().length;
  int get totalNumberOfCharacters =>
      fold(0, (prev, word) => prev + word.length);
}

extension RandomExt on Random {
  /// we'll use the maximum allowable radix base (allowed by `toRadixString`)
  /// to maximally speed up sampling
  static const base = 36;
  static const digits = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];

  static const digitsEncoder = {
    '0': 0,
    '1': 1,
    '2': 2,
    '3': 3,
    '4': 4,
    '5': 5,
    '6': 6,
    '7': 7,
    '8': 8,
    '9': 9,
    'a': 10,
    'b': 11,
    'c': 12,
    'd': 13,
    'e': 14,
    'f': 15,
    'g': 16,
    'h': 17,
    'i': 18,
    'j': 19,
    'k': 20,
    'l': 21,
    'm': 22,
    'n': 23,
    'o': 24,
    'p': 25,
    'q': 26,
    'r': 27,
    's': 28,
    't': 29,
    'u': 30,
    'v': 31,
    'w': 32,
    'x': 33,
    'y': 34,
    'z': 35,
  };

  /// Sample a `BigInt` in the range [0, i).
  BigInt nextBigInt(BigInt i) {
    assert(i > BigInt.from(0));
    final iEncoded =
        i.toRadixString(base).split('').map((c) => digitsEncoder[c]!).toList();
    final sample = List<int>.filled(iEncoded.length, 0);
    bool obeyUpperBound = true;
    for (var j = 0; j < iEncoded.length; j++) {
      sample[j] = nextInt(obeyUpperBound ? iEncoded[j] : base);
      if (obeyUpperBound && sample[j] < iEncoded[j]) {
        obeyUpperBound = false;
      }
    }
    return BigInt.parse(sample.map((e) => digits[e]).join(), radix: base);
  }
}
