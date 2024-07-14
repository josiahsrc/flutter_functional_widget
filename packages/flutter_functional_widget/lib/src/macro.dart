import 'dart:async';

import 'package:macros/macros.dart';

extension on DeclarationBuilder {
  void reportError(String message, {DiagnosticTarget? target}) {
     report(Diagnostic(
        DiagnosticMessage(
          'Expected no parameters, and a return type of '
          'Map<String, Object?>',
          target: target,
        ),
        Severity.warning,
      ),
    );
  }
}

macro class Functional implements FunctionDeclarationsMacro {
  const Functional();

  @override
  Future<void> buildDeclarationsForFunction(
    FunctionDeclaration function, 
    DeclarationBuilder builder,
  ) async {
    final originalName = function.identifier.name;
    if (originalName.length < 2) {
      return builder.reportError('Functional widget name is too short');
    }

    if (!originalName.startsWith('_')) {
      return builder.reportError('Functional widget name must start with an underscore followed by a letter');
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(originalName[1])) {
      return builder.reportError('Functional widget name must start with an underscore followed by a letter');
    }

    final redirectName = _getRedirectName(originalName);

    final firstParamType = function.positionalParameters.firstOrNull?.type;
    if (firstParamType is! NamedTypeAnnotation) {
      return builder.reportError('The first parameter must be the BuildContext');
    }

    if (firstParamType.identifier.name != 'BuildContext') {
      return builder.reportError('The first parameter must be the BuildContext');
    }

    List<String> defParams = [];
    List<String> callParams = [];
    for (final param in function.namedParameters) {
      final paramType = param.type;
      if (paramType is! NamedTypeAnnotation) {
        return builder.reportError('All parameters must have a type');
      }

      final defSb = StringBuffer();
      if (param.isRequired) {
        defSb.write('required ');
      }

      defSb.write(paramType.identifier.name);
      if (paramType.isNullable) {
        defSb.write('?');
      }

      defSb.write(' ');
      defSb.write(param.identifier.name);

      defParams.add(defSb.toString());

      final callSb = StringBuffer();
      callSb.write(param.identifier.name);
      callSb.write(': ');
      callSb.write(param.identifier.name);

      callParams.add(callSb.toString());
    }

    builder.declareInLibrary(
      DeclarationCode.fromString('''
import 'package:flutter/material.dart';

Widget $redirectName({
  Key? key,
  ${defParams.join(',\n\t')}
}) {
  return Builder(
    key: key,
    builder: (context) {
      return $originalName(
        context,
        ${callParams.join(',\n\t')}
      );
    },
  );
}
      '''),
    );
  }
}

String _getRedirectName(String name) {
  final remaining = name.substring(1);
  final firstLetter = remaining[0].toUpperCase();
  final res = firstLetter + remaining.substring(1);
  return res;
}
