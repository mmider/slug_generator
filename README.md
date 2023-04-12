# Slug generator

A pure [dart](https://dart.dev/) implementation of a random slug generator.

Do you recall these funny random strings used all over the internet as alternatives to uuids for naming repositories/projects/objects, like: `defiant-fluffy-eagle-of-reward` or `big-augmented-lori-of-cookies`? With this package you can generate random strings like these yourself (we refer to them as [slugs](https://developer.mozilla.org/en-US/docs/Glossary/Slug)).

> :information_source: This package has been ported (with some simplifications/changes to implementation) from a Python package [coolname](https://github.com/alexanderlukanin13/coolname). Please bear in mind, however, that I am NOT associated with, nor contributed to [coolname](https://github.com/alexanderlukanin13/coolname).

## Features

Generate random slugs:

```dart
final rng = Random(42)

// To generate a slug
final slug = rng.nextSlug();
// slug == 'glistening-inventive-loon-from-atlantis'

// To generate a tokenized slug
final tokens = rng.nextSlugToken();
// tokens == <String>['loutish', 'imaginary', 'anteater', 'of', 'competence']
```

## Getting started

Add `slug_generator` to your `pubspec.yaml`:

```yaml
dependencies:
  pubspec: ^x.x.x # replace x.x.x with the latest version
```

Then, inside your project, whenever you want to generate a slug import `math` (which contains `Random`), as well as this package (which provides extensions for slug generation):

```dart
import 'dart:math' show Random;
import 'package:slug_generator/slug_generator.dart';
```

## Usage

Simply call `nextSlug` or `nextSlugToken` on an instance of `Random` to generate slugs or tokenized slugs respecitvely:

```dart
final rng = Random(42)

// To generate a slug
final slug = rng.nextSlug();
// slug == 'glistening-inventive-loon-from-atlantis';

// To generate a tokenized slug
final tokens = rng.nextSlugToken();
// tokens == <String>['loutish', 'imaginary', 'anteater', 'of', 'competence'];
// You can do whatever you want with the tokens, for instance:
final phrase = tokens.map((e)=>"${e[0].toUpperCase()}${e.substring(1)}").join(' ');
// phrase == 'Loutish Imaginary Anteater Of Competence';
```

Optionally, you may pass a specific collection as a parameter to either of `nextSlug` or `nextSlugToken` in order to sample only from that collection. For instance:

```dart
// Sample slugs of length 2
rng.nextSlug(Collections.two);

// Sample slugs of length 3
rng.nextSlug(Collections.three);

// Sample slugs of length 4
rng.nextSlug(Collections.four);

// Sample slugs from all available collections (default)
rng.nextSlug(Collections.all);
```

The table below shows orders for the number of unique slugs of given length that can be generated using this package:

| Words | Combinations | Example                              |
| ----- | ------------ | ------------------------------------ |
| 4     | $10^{10}$    | `lumpy-agouti-of-unknown-enthusiasm` |
| 3     | $10^8$       | `speedy-thistle-starling`            |
| 2     | $10^5$       | `whimsical-dodo`                     |

## For advanced users

You may want to define your own word collections and pass them to `nextSlug`. See file `data_containers.dart` to understand the data structures used for defining word collections and see files `words_vault.dart` and `collections.dart` for examples of word collections.

## Additional information

If you would like to contribute, consider expanding upon the package's word collection by adding new terms. Before doing so however, please make sure that

1. The word really fits to where you want to add it
1. The term is not already present (in case of two-word terms also make sure that it is not possible to construct the term through composition of already existing words)
1. The word is not offensive (we try to be neutral or positive, hence the heavy reliance of this package's dictionary on the mother nature's terminology)
