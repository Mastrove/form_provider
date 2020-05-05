import 'dart:async';

import 'package:flutter/widgets.dart';

import '../modules/blur_handler.dart';
import '../modules/f_nodes.dart';
import '../modules/validator.dart';

class FormModel {
  Map<String, Validator> validationSchema = {};
  final Map<String, dynamic> values = {};
  final FNodes fNodes;
  final _validationStream = StreamController<Map<String, String>>.broadcast();

  Map<String, String> validationResult;

  FormModel({
    BuildContext context,
  }) : fNodes = FNodes(context: context);

  register({
    String attribute,
    dynamic initialValue,
    Validator validator,
  }) {
    validationSchema[attribute] = validator;
    values[attribute] = values[attribute] ?? initialValue ?? '';
    _validateForm();
  }

  requestFocusNode({
    String attribute,
  }) {
    final node = fNodes.getNode(attribute);
    return node;
  }

  _validateForm() {
    validationResult = schemaValidator(validationSchema)(values);
    _validationStream.sink.add(validationResult);
  }

  updateValue(String attribute, dynamic value) {
    if (!values.containsKey(attribute)) {
      throw Exception(
        'form field with attribute $attribute has not been registered',
      );
    }

    values[attribute] = value;

    _validateForm();
  }

  Stream<Map<String, String>> get validationStream => _validationStream.stream;

  dispose() {
    _validationStream.close();
  }
}
