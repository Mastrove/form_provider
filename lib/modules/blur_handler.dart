import 'package:flutter/widgets.dart';

class BlurHandler extends ChangeNotifier {
  final FocusNode node;
  bool blurred = false;
  bool _hasHadFocus = false;

  BlurHandler(this.node) {
    node.addListener(handleFocusChange);
  }

  handleFocusChange() {
    if(blurred) return;
    if (node.hasFocus && !_hasHadFocus) {
      _hasHadFocus = true;
    } else if (!node.hasFocus) {
      blurred = _hasHadFocus;
      notifyListeners();
    }
  }

  reset() {
    blurred = false;
    _hasHadFocus = false;
    notifyListeners();
  }
}
