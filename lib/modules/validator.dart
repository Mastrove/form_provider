import 'package:validators/validators.dart' as validator;

typedef TValidator = String Function(String value);

TValidator emailValidator([String error, String label]) {
  return (String value) {
    final isValid = validator.isEmail(value);
    return isValid ? null : error ?? '$label is not a valid email';
  };
}

TValidator isLengthValidator(int min, [int max, String error, String label]) {
  return (String value) {
    final isValid = validator.isLength(value, min, max);
    return isValid ? null : error ?? '$label does not meet length constraints';
  };
}

TValidator isIntValidator([String error, String label]) {
  return (String value) {
    final isValid = validator.isInt(value);
    return isValid ? null : error ?? '$label must be a valid number';
  };
}

TValidator equalsValidator(String val, [String error, String label]) {
  return (String value) {
    final isValid = !validator.equals(value, val);
    return isValid ? null : error ?? '$label must be equal to $val';
  };
}

TValidator isInValidator(List<dynamic> values, [String error, String label]) {
  return (String value) {
    final isValid = validator.isIn(value, values);
    return isValid ? null : error ?? '$label must be in $values';
  };
}

TValidator isNumericValidator([String error, String label]) {
  return (String value) {
    final isValid = validator.isNumeric(value);
    return isValid ? null : error ?? '$label must contain only number';
  };
}

typedef TCustomValidatorCallback = String Function(dynamic value, Map<String, dynamic> data);

class Validator {
  List<TValidator> validators = [];
  String _label = 'field';
  bool _isOptional = true;
  String _isRequiredError;
  Map<String, dynamic> values = {};

  label(String label) {
    _label = label;
  }

  email([String error]) {
    validators.add(emailValidator(error, _label));
  }

  isLength(min, [max, String error]) {
    validators.add(isLengthValidator(min, max, error, _label));
  }

  isInt([String error]) {
    validators.add(isIntValidator(error, _label));
  }

  equals(String value, [String error]) {
    validators.add(equalsValidator(value, error, _label));
  }

  isIn(List<dynamic> values, [String error]) {
    validators.add(isInValidator(values, error, _label));
  }

  isNumeric([String error]) {
    validators.add(isNumericValidator(error));
  }

  isRequired([String error]) {
    _isOptional = false;
    _isRequiredError = error;
  }

  custom(TCustomValidatorCallback validator) {
    validators.add((dynamic value) {
      return validator(value, values);
    });
  }

  Validator get validator => this;

  TValidator validate() {
    return (dynamic value) {
      if ((value == null) || (value == '')) {
        if (_isOptional) return null;
        else return _isRequiredError ?? '$_label is required';
      }

      for (var i = 0; i < validators.length; i++) {
        final error = validators[i](value);
        if (error != null) return error;
      }
      return null;
    };
  }
}

typedef SchemaValidator = Map<String, String> Function(Map<String, dynamic> data);

SchemaValidator schemaValidator(Map<String, Validator> schema) {
  return (Map<String, dynamic> data) {
    final Map<String, String> errorMap = {};

    schema.forEach((key, validator) {
      validator.values = data;
      final field = data[key];
      final error = (validator..label(key)).validate()(field);
      if (error != null) errorMap[key] = error;
    });

    return errorMap.isEmpty ? null : errorMap;
  };
}
