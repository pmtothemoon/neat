import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'dart:core';

import 'src/anotations.dart';
import 'src/generators/space_generators.dart';

Builder neatGenerator(BuilderOptions options) {
  final formater = DartFormatter();
  return LibraryBuilder(
    NeatGenerator(),
    formatOutput: formater.format,
    generatedExtension: ".nt.dart",
    header: """

/// Generated by neat
///
/// This file has been generated
/// Do not modify by hand

import 'package:flutter/widgets.dart';
""",
  );
}

// Runs for anything annotated as deprecated
class NeatGenerator extends GeneratorForAnnotation<NeatAnotation> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader anotation,
    __,
  ) {
    //TODO: parse config
    if (element.isPublic && element is ClassElement) {
      return element.fields
          .map((field) => SpaceWidgetGenerator.tryGenerate(
                field,
                NeatAnotation(),
              ))
          .toList()
          .join("\n");
    }
    throw ("@neat anotation should only be used on a plublic class");
  }
}
