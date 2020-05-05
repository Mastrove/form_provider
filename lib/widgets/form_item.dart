import 'package:flutter/widgets.dart';
import 'package:form_provider/models/form.dart';
import 'package:form_provider/models/form_item.dart';
import 'package:form_provider/modules/validator.dart';

class FormItem<T> extends StatefulWidget {
  final dynamic initialValue;
  final Validator validator;
  final String attribute;
  final Widget Function(FormBag<T> bag) builder;
  final FormModel model;

  FormItem({
    this.initialValue = '',
    this.validator,
    this.attribute,
    this.builder,
    this.model,
  });

  @override
  _FormItemState createState() => _FormItemState<T>();
}

class _FormItemState<T> extends State<FormItem<T>> {
  FormBag bag;
  Widget child;

  @override
  void initState() {
    super.initState();
    bag = FormBag<T>(
      validator: widget.validator,
      model: widget.model,
      attribute: widget.attribute,
      initialValue: widget.initialValue,
      onBlur: () {
        _reuildWidget();
      },
      onDirtied: () {
        _reuildWidget();
      },
    );

    bag.validationStream.listen(
      (errors) {
        _reuildWidget();
      }
    );

    child = widget.builder(bag);

    // renderChild();
  }

  @override
  void didUpdateWidget(FormItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    widget.model.register(
      attribute: widget.attribute,
      validator: widget.validator,
    );
  }

  _reuildWidget() {
    setState(() {
       child = widget.builder(bag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
