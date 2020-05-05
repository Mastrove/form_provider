import 'package:flutter/material.dart';
import 'package:form_provider/models/form.dart';
import 'package:form_provider/modules/validator.dart';
import 'package:form_provider/widgets/form_item.dart';

class Form extends StatefulWidget {
  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<Form> {

  FormModel formModel;

  @override
  void initState() {
    super.initState();
    formModel = FormModel(
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FormItem(
        model: formModel,
        validator: Validator(),
        attribute: 'item1',
        initialValue: 'yes',
        builder: (bag) {
          return TextFormField(
            autovalidate: bag.pristine,
            initialValue: bag.value,
            focusNode: bag.focusNode,
            validator: (_) {
              if (bag.touched) return bag.validationError;
              return null;
            },
            onChanged: bag.setValue,
          );
        }
      )
    );
  }
}
