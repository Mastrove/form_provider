import 'package:flutter/widgets.dart';
import 'package:form_provider/models/form.dart';
import 'package:form_provider/modules/blur_handler.dart';
import 'package:form_provider/modules/validator.dart';

typedef FormItemBuilder<T> = Widget Function(FormBag<T> bag);

class FormBag<T extends Object> {
  final T initialValue;
  final Validator validator;
  final String attribute;
  final FormModel model;
  final void Function() onBlur;
  final void Function() onDirtied;
  TextEditingController _controller;
  BlurHandler blurHandler;
  FocusNode _focusNode;
  bool pristine = true;

  FormBag({
    this.initialValue,
    this.validator,
    this.attribute,
    this.model,
    this.onBlur,
    this.onDirtied,
  }) {
    model.register(
      attribute: attribute,
      initialValue: initialValue,
      validator: validator,
    );
  }

  TextEditingController get controller {
    if (_controller != null) return _controller;

    if (true) {
      _controller = TextEditingController(
        text: initialValue as String,
      );

      _controller.addListener(() {
        setValue(_controller.text as T);
      });
    }

    return _controller;
  }

  T get value => model.values[attribute];

  void setValue(T value) {
    if (value == model.values[attribute]) return;

    if (pristine) {
      pristine = false;
      onDirtied();
    }

    model.updateValue(attribute, value);
  }

  FocusNode get focusNode {
    if (_focusNode != null) return _focusNode;

    _focusNode = model.requestFocusNode(
      attribute: attribute,
    );

    blurHandler = BlurHandler(_focusNode)..addListener(onBlur);

    return focusNode;
  }

  String Function(dynamic val) isValid ([bool Function() condition]) {
    final conditionFn = condition == null ? () => true : condition;
  
    return (dynamic val) {
      if (conditionFn()) {
        return validationError;
      } else {
        return null;
      }
    };
  }

  bool get touched => blurHandler == null ? false : blurHandler.blurred;

  String get validationError =>
      model.validationResult == null ? null : model.validationResult[attribute];

  Stream<Map<String, String>> get validationStream => model.validationStream;
}
